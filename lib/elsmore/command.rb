require 'commander'
require 'awesome_print'

module Elsmore
  class Command
    include Commander::Methods

    def run
      program :name, 'elsmore'
      program :version, Elsmore::VERSION
      program :description, 'A convenient scraper for archiving sites'

      command :spider do |c|
        c.syntax = 'spider <url> [options]'
        c.description = 'Spiders a URL within from the given page, sticking within the original domain'
        c.action do |args, options|
          result = Elsmore::Scraper.new(args.first).start

          say "\n\nProcessed"
          ap result[:processed]

          say "Could not be processed"
          ap result[:invalid]
        end
      end
      run!
    end
  end
end
