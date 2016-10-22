require 'awesome_print'

module Elsmore
  class Emitter
    def newline
      say "\n"
    end

    def say value
      puts value
    end

    def dot
      print "."
    end

    def x
      print "x"
    end

    def pretty value
      ap value
    end
  end
end
