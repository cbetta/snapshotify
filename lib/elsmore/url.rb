require 'httparty'
require 'oga'

module Elsmore
  class Url
    attr_accessor :url, :parent, :valid

    def initialize url, parent = nil
      self.url = url
      self.parent = parent
      self.valid = true

      full_uri
    end

    def links
      @links ||= begin
        doc.xpath('//a').map do |element|
          element.attribute('href')
        end.compact.map(&:value).map do |href|
          Elsmore::Url.new(href, self)
        end.compact
      end
    end

    def doc
      @doc ||= begin
        html = HTTParty.get(full_uri)
        Oga.parse_html(html)
      end
    end

    def write!
    end

    def host
      @host ||= full_uri.host
    end

    def full_url
      @full_url ||= full_uri.to_s
    end

    def full_uri
      @full_uri ||= begin
        uri = URI.parse(url.strip)

        unless uri.is_a?(URI::Generic)
          self.valid = false
          return nil
        end

        uri = URI.parse("http://#{uri.to_s}") if uri.scheme.nil?
        uri.scheme = 'http' unless ['http', 'https'].include?(uri.scheme)
        uri.fragment = nil
        uri.path = "/" if uri.path.empty?

        uri.host = parent.host if uri.host.nil? && parent
        uri
      rescue
        print "x"
        self.valid = false
        nil
      end
    end
  end
end
