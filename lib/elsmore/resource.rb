require 'open-uri'

module Elsmore
  class Resource
    attr_accessor :url, :filename

    def initialize url, parent
      self.url = Elsmore::Url.new(url, parent)
    end

    def write!
      writer = Elsmore::Writer.new(self)
      writer.write
      self.filename = writer.canonical_filename
    end

    def data
      @data ||= open(url.canonical_url).read
    end
  end
end
