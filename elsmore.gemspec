require File.expand_path('lib/elsmore/version', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name        = 'elsmore'
  s.version     =  Elsmore::VERSION
  s.summary     = "Backup too for Hackference"
  s.description = "Backup too for Hackference"
  s.authors     = ["Cristiano Betta", "Mike Elsmore"]
  s.email       = ['cbetta@gmail.com', "mike@hackference.co.uk"]
  s.files         = `git ls-files`.split("\n")
  s.homepage    = 'https://github.com/cbetta/elsmore'
  s.license     = 'MIT'
  s.require_paths = ["lib"]
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }


  s.add_development_dependency('rake')

  s.add_dependency('commander')
  s.add_dependency('httparty')
  s.add_dependency('oga')
  s.add_dependency('awesome_print')
  s.add_dependency('colorize')
end
