require 'open-uri'

module Elsmore
  class Scraper
    def initialize url
      @url = url
    end

    def start
      Elsmore::Spider.new(@url).start
    end
  end
end
