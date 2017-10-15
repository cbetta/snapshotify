module Snapshotify
  # A scraper that starts with an initial URLs
  # and downloads every page, rewrites all links and referenced files
  # and adds them to be downloaded as well
  class Scraper
    attr_accessor :seed, :emitter, :unprocessed_documents, :processed_urls, :invalid_urls, :unprocessed_urls, :valid_domains

    def initialize initial_url
      self.seed = Snapshotify::Document.new(initial_url)

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
      return unless document.valid
      # If we're debugging, output the canonical_url
      emitter.log(document.url.canonical_url.colorize(:green))
      # Attach the emitter to the document
      document.emitter = emitter
      # enqueue any other pages being linked to
      enqueue(document.links)

      # rewrite all absolute links, asset urls, etc
      # to use local, relative paths
      # document.rewrite

      # Write the document to file
      document.write!

      # Mark this document's canonical_url as processed
      processed_urls << document.url.canonical_url
    end

    # Enqueue new documents for each link
    # found in the current document
    def enqueue links
      # Loop over each document
      links.each_with_index do |document, index|
        next unless can_be_enqueued?(document)

        emitter.log("> Enqueueing: #{document.url.canonical_url}")

        unprocessed_documents << document
        unprocessed_urls << document.url.canonical_url
      end
    end

    # Determine if a document can be enqueued
    def can_be_enqueued?(document)
      archivable?(document) &&
      # ensure the next document is on an allowable domain
      valid_domains.include?(document.url.host) &&
      # ensure the next document hasn't been processed yet
      !processed_urls.include?(document.url.canonical_url) &&
      # ensure the next document hasn't been enqueued yet
      !unprocessed_urls.include?(document.url.canonical_url)
    end

    # Determine if a document is actually the type of document
    # that can be archived
    def archivable?(document)
      # check if the document is likely to be a html page
      archivable_document = document.url.valid

      # check of the document hasn't already been evaluated and discarded
      has_been_marked_as_invalid = self.invalid_urls.include?(document.url.raw_url)

      # Add the dpcument to the list of needed
      if !archivable_document && !has_been_marked_as_invalid
        emitter.warning("> Invalid URL: #{document.url.raw_url}")
        invalid_urls << document.url.raw_url
      end
      archivable_document
    end
  end
end
