require 'awesome_print'
require 'colorize'

module Elsmore
  class Emitter
    def newline
      say "\n"
    end

    def say value
      puts value
    end

    def dot
      print ".".colorize(:blue)
    end

    def x
      print "x".colorize(:red)
    end

    def pretty value
      ap value
    end
  end
end
