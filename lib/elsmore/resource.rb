require 'httparty'

module Elsmore
  class Resource
    attr_accessor :url, :filename, :emitter

    def initialize url, parent
      self.url = Elsmore::Url.new(url, parent)
    end

    def write!
      writer = Elsmore::Writer.new(self)
      writer.emitter = emitter
      writer.write
      self.filename = writer.canonical_filename
    end

    def data
      @data ||= HTTParty.get(url.canonical_url)
    end
  end
end
