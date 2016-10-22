module Elsmore
  class Scraper
    attr_accessor :emitter, :unprocessed, :processed, :invalid, :unprocessed_urls, :valid_domains

    def initialize initial_url
      seed = Elsmore::Document.new(initial_url)

      self.valid_domains = [seed.url.host]

      self.unprocessed = [seed]
      self.unprocessed_urls = [seed.url.canonical_url]

      self.processed = []
      self.invalid = []
    end

    def run
      while !unprocessed.empty?
        document = unprocessed.shift
        process document
      end
      self
    end

    private

    def process document
      emitter.log(document.url.canonical_url.colorize(:green))

      document.emitter = emitter

      enqueue(document.links)
      document.rewrite
      document.write!

      processed << document.url.canonical_url
    end

    def enqueue links
      links.each_with_index do |document, index|
        next unless valid?(document)
        next if !valid_domains.include?(document.url.host)
        next if processed.include?(document.url.canonical_url)
        next if unprocessed_urls.include?(document.url.canonical_url)

        emitter.log("> Enqueued: #{document.url.canonical_url}")

        unprocessed << document
        unprocessed_urls << document.url.canonical_url
      end
    end

    def valid?(document)
      if !document.url.valid && !self.invalid.include?(document.url.raw_url)
        emitter.warning("> Invalid URL: #{document.url.raw_url}")
        invalid << document.url.raw_url
      end
      document.url.valid
    end
  end
end
