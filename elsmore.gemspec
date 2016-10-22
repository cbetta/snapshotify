require File.expand_path('lib/elsmore/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = 'elsmore'
  s.version     =  Elsmore::VERSION
  s.summary     = "Backup too for Hackference"
  s.description = "Backup too for Hackference"
  s.authors     = ["Cristiano Betta", "Mike Elsmore"]
  s.email       = ['cbetta@gmail.com', "mike@hackference.co.uk"]
  s.files       = Dir.glob('{lib,spec}/**/*') + %w(LICENSE README.md elsmore.gemspec)
  s.homepage    = 'https://github.com/cbetta/elsmore'
  s.license     = 'MIT'
  s.require_path = 'lib'

  s.add_development_dependency('rake')

  s.add_dependency('commander')
  s.add_dependency('httparty')
  s.add_dependency('oga')
  s.add_dependency('awesome_print')
  s.add_dependency('colorize')
end
