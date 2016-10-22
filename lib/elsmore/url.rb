require 'httparty'
require 'oga'

module Elsmore
  class Url
    def initialize url, parent = nil
      @url = url
      @parent = parent
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
        # ap @url.strip
        uri = URI.parse(@url.strip)
        return @parent.full_uri if uri.is_a?(URI::MailTo)

        uri = URI.parse("http://#{uri.to_s}") if uri.scheme.nil?
        uri.host = @parent.host if uri.host.nil? && @parent
        uri
      rescue
        ap "Could not parse #{@url}"
        @parent.full_uri
      end
    end
  end
end
