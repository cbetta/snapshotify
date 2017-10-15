require 'commander'

module Snapshotify
  class Command
    include Commander::Methods

    attr_accessor :emitter

    def initialize
      self.emitter = Snapshotify::Emitter.new
    end

    def run
      program :name, 'snapshotify'
      program :version, Snapshotify::VERSION
      program :description, 'A convenient scraper for archiving sites'
      program :help, 'Author', 'Cristiano Betta <cristiano@betta.io>'

      global_option('--debug') { emitter.debug! }

      command :snap do |c|
        c.syntax = 'spider <url>'
        c.description = 'Spiders a URL within from the given page, sticking within the original domain'
        c.action do |args, options|
          scraper = Snapshotify::Scraper.new(args.first)
          scraper.emitter = emitter
          scraper.run

          emitter.newline
          emitter.newline
          emitter.say "Processed"
          emitter.pretty scraper.processed
          emitter.newline
          emitter.say "Could not be processed"
          emitter.pretty scraper.invalid

          emitter.newline
          emitter.say "Run 'snapshotify serve #{args.first}' to start a webserver on port 8000 with your local copy"
        end
      end
      default_command :snap

      command :serve do |c|
        c.syntax = 'serve <folder_name>'
        c.description = 'Serve local folder'
        c.action do |args, options|
          exec "ruby -run -ehttpd ./#{ARGV[1]} -p8000"
        end
      end

      run!
    end
  end
end
