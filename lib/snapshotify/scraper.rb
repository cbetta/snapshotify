module Snapshotify
  # A scraper that starts with an initial URLs
  # and downloads every page, rewrites all links and referenced files
  # and adds them to be downloaded as well
  class Scraper
    attr_accessor :emitter, :unprocessed_documents, :processed_urls, :invalid_urls, :unprocessed_urls, :valid_domains

    def initialize initial_url
      seed = Snapshotify::Document.new(initial_url)

      # keep track of all domains we will allow to spider
      self.valid_domains = [seed.url.host]
      # add the document to the list to process
      self.unprocessed_documents = [seed]
      # TODO: see if we can drop this
      self.unprocessed_urls = [seed.url.canonical_url]
      # keep track of what URLs we've processed
      self.processed_urls = []
      # keep track of what URLs we've ignored
      self.invalid_urls = []
    end

    # Loop over a site from the seed,
    # fetching all the pages and processing them
    def run
      # TODO: Write progress to a file so we
      # can pick up progress if things crash

      # Loop over the remaining unprocessed documents
      while !unprocessed_documents.empty?
        process unprocessed_documents.shift
      end
      self
    end

    private

    # Process a document, fetching its content and enqueueing it for
    # sub processing
    def process document
      # If we're debugging, output the canonical_url
      emitter.log(document.url.canonical_url.colorize(:green))
      # Attach the emitter tp the document
      document.emitter = emitter

      # enqueue(document.links)

      # rewrite all absolute links, asset urls, etc
      # to use local, relative paths
      # document.rewrite

      # Write the document to file
      document.write!

      # Mark this document's canonical_url as processed
      processed_urls << document.url.canonical_url
    end

    # def enqueue links
    #   links.each_with_index do |document, index|
    #     next unless valid?(document)
    #     next if !valid_domains.include?(document.url.host)
    #     next if processed_urls.include?(document.url.canonical_url)
    #     next if unprocessed_urls.include?(document.url.canonical_url)
    #
    #     emitter.log("> Enqueued: #{document.url.canonical_url}")
    #
    #     unprocessed_documents << document
    #     unprocessed_urls << document.url.canonical_url
    #   end
    # end

    # def valid?(document)
    #   if !document.url.valid && !self.invalid_urls.include?(document.url.raw_url)
    #     emitter.warning("> Invalid URL: #{document.url.raw_url}")
    #     invalid_urls << document.url.raw_url
    #   end
    #   document.url.valid
    # end
  end
end
