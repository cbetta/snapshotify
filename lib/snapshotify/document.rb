require 'httparty'
require 'oga'

module Snapshotify
  # The representation of a specific document within the site
  class Document
    attr_accessor :url, :emitter

    # Initialize the document with a URL, and
    # the parent page this URL was included on in case of
    # assets
    def initialize url, parent = nil
      # initialize  URL helper
      self.url = Snapshotify::Url.new(url, parent)
    end

    # def links
    #   @links ||= begin
    #     doc.xpath('//a').map do |element|
    #       element.attribute('href')
    #     end.compact.map(&:value).map do |href|
    #       Snapshotify::Document.new(href, url)
    #     end.compact
    #   end
    # end

    # The XML data for this document
    def data
      doc.to_xml
    end

    # Write a document to file
    def write!
      writer = Snapshotify::Writer.new(self)
      writer.emitter = emitter
      writer.write
    end

    # def rewrite
    #   rewriter = Snapshotify::Rewriter.new(self)
    #   rewriter.emitter = emitter
    #   rewriter.rewrite
    # end
    #

    # Parse the XML for the document
    def doc
      html = HTTParty.get(url.canonical_url)
      Oga.parse_html(html)
    end
  end
end
