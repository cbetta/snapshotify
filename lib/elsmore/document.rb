require 'httparty'
require 'oga'

module Elsmore
  class Document
    attr_accessor :url, :emitter

    def initialize url, parent = nil
      self.url = Elsmore::Url.new(url, parent)
    end

    def links
      @links ||= begin
        doc.xpath('//a').map do |element|
          element.attribute('href')
        end.compact.map(&:value).map do |href|
          Elsmore::Document.new(href, url)
        end.compact
      end
    end

    def data
      doc.to_xml
    end

    def write!
      writer = Elsmore::Writer.new(self)
      writer.emitter = emitter
      writer.write
    end

    def rewrite
      rewriter = Elsmore::Rewriter.new(self)
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
