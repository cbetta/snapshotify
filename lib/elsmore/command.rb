require 'commander'

module Elsmore
  class Command
    include Commander::Methods

    def run
      program :name, 'scrape'
      program :version, Elsmore::VERSION
      program :description, 'Scrapes a full website'

      command :scrape do |c|
        c.syntax = 'scrape <url> [options]'
        c.description = 'Scrapes a URL'
        c.action do |args, options|
          Elsmore::Scraper.new(args.first).start
        end
      end
      run!
    end
  end
end
