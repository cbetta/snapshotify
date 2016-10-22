require 'httparty'
require 'oga'

module Elsmore
  class Document
    attr_accessor :url

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

    def doc
      @doc ||= begin
        html = HTTParty.get(url.canonical_url)
        Oga.parse_html(html)
      end
    end

    def write!
      Elsmore::Writer.new(self).write
    end

    def rewrite
      Elsmore::Rewriter.new(self).rewrite
    end
  end
end
