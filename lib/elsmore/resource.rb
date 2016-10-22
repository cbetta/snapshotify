module Elsmore
  class Resource
    attr_accessor :url

    def initialize url, parent
      self.url = Elsmore::Url.new(url, parent)
    end
  end
end
