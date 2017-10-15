require 'httparty'
require 'oga'

module Snapshotify
  class Document
    attr_accessor :url, :emitter

    def initialize url, parent = nil
      self.url = Snapshotify::Url.new(url, parent)
    end

    def links
      @links ||= begin
        doc.xpath('//a').map do |element|
          element.attribute('href')
        end.compact.map(&:value).map do |href|
          Snapshotify::Document.new(href, url)
        end.compact
      end
    end

    def data
      doc.to_xml
    end

    def write!
      writer = Snapshotify::Writer.new(self)
      writer.emitter = emitter
      writer.write
    end

    def rewrite
      rewriter = Snapshotify::Rewriter.new(self)
      rewriter.emitter = emitter
      rewriter.rewrite
    end

    def doc
      @doc ||= begin
        html = HTTParty.get(url.canonical_url)
        Oga.parse_html(html)
      end
    end
  end
end
