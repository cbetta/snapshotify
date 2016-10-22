module Elsmore
  class Spider
    def initialize initial_url
      seed = Elsmore::Url.new(initial_url)
      @valid_domains = [seed.host]
      @unprocessed = [seed]
      @processed = []
      @invalid = []
    end

    def start
      while !@unprocessed.empty?
        url = @unprocessed.shift
        next if @processed.include?(url.full_url)
        print "."

        enqueue(url.links)
        url.write!

        @processed << url.full_url
      end

      {
        processed: @processed,
        invalid: @invalid
      }
    end

    private

    def enqueue links
      links.each_with_index do |link, index|
        if !link.valid
          @invalid << link.url
          next
        end

        next if !@valid_domains.include?(link.host)
        next if @processed.include?(link.full_url)
        @unprocessed << link
      end
    end
  end
end
