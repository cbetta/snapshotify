require 'awesome_print'

module Elsmore
  class Spider
    def initialize initial_url
      seed = Elsmore::Url.new(initial_url)
      @valid_domains = [seed.host]
      @unprocessed = [seed]
      @processed = []
    end

    def start
      while !@unprocessed.empty?
        url = @unprocessed.shift
        next if @processed.include?(url.full_url)
        ap "Processing #{url.full_url}"

        enqueue(url.links)
        url.write!

        @processed << url.full_url
      end

      ap @processed
    end

    private

    def enqueue links
      links.each_with_index do |link, index|
        next if !@valid_domains.include?(link.host)
        next if @processed.include?(link.full_url)
        @unprocessed << link
      end
    end
  end
end
