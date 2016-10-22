require 'awesome_print'
require 'colorize'

module Elsmore
  class Emitter
    attr_accessor :debug

    def initialize
      self.debug = false
    end

    def debug!
      self.debug = true
    end

    def newline
      puts "\n"
    end

    def pretty value
      ap value
    end

    def log message
      if debug
        puts message
      else
        print ".".colorize(:green)
      end
    end

    def warning message
      if debug
        puts message.colorize(:yellow)
      else
        print ".".colorize(:yellow)
      end
    end
  end
end
