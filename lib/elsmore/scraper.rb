module Elsmore
  class Scraper
    attr_accessor :emitter

    def initialize initial_url
      seed = Elsmore::Document.new(initial_url)

      @valid_domains = [seed.url.host]
      @unprocessed = [seed]
      @processed = []
      @invalid = []
    end

    def run
      while !@unprocessed.empty?
        document = @unprocessed.shift
        next if @processed.include?(document.url.canonical_url)
        emitter.dot

        enqueue(document.links)
        document.write!

        @processed << document.url.canonical_url
      end

      {
        processed: @processed,
        invalid: @invalid
      }
    end

    private

    def enqueue links
      links.each_with_index do |document, index|
        if !document.url.valid
          emitter.unsure
          @invalid << document.url.raw_url
          next
        end

        next if !@valid_domains.include?(document.url.host)
        next if @processed.include?(document.url.canonical_url)
        @unprocessed << document
      end
    end
  end
end
