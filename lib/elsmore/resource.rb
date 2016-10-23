require 'httparty'

module Elsmore
  class Resource
    attr_accessor :url, :filename, :emitter, :parent

    def initialize url, parent
      self.url = Elsmore::Url.new(url, parent)
      self.parent = parent
    end

    def write! nested_urls = false
      process_nested_urls if nested_urls

      writer = Elsmore::Writer.new(self)
      writer.emitter = emitter
      writer.write
      self.filename = writer.canonical_filename
    end

    def data
      @data ||= HTTParty.get(url.canonical_url)
    end

    private

    def process_nested_urls
      urls = data.scan(/url\((.*?)\)/i).map do |match|
        if match[0].start_with?('"') || match[0].start_with?("'")
          match[0][1...-1]
        else
          match[0]
        end
      end

      urls.each do |nested_url|
        resource = Elsmore::Resource.new(nested_url, url)
        resource.emitter = emitter
        resource.write!

        @data.gsub!(nested_url, resource.url.resource_path)
      end
    end
  end
end
