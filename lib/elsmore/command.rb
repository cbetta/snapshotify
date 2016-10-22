require 'commander'

module Elsmore
  class Command
    include Commander::Methods

    attr_accessor :emitter

    def initialize
      self.emitter = Elsmore::Emitter.new
    end

    def run
      program :name, 'elsmore'
      program :version, Elsmore::VERSION
      program :description, 'A convenient scraper for archiving sites'
      program :help, 'Author', 'Cristiano Betta <cristiano@betta.io>'

      command :snap do |c|
        c.syntax = 'spider <url> [options]'
        c.description = 'Spiders a URL within from the given page, sticking within the original domain'
        c.action do |args, options|
          scraper = Elsmore::Scraper.new(args.first)
          scraper.emitter = emitter
          result = scraper.run

          emitter.newline
          emitter.newline
          emitter.say "Processed"
          emitter.pretty result[:processed]
          emitter.newline
          emitter.say "Could not be processed"
          emitter.pretty result[:invalid]
        end
      end
      alias_command :'go fetch', :'snap'
      default_command :snap


      run!
    end
  end
end
