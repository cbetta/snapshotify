$:.push File.expand_path("../lib", __FILE__)
require "elsmore/version"

Gem::Specification.new do |s|
  s.name        = 'elsmore'
  s.version     =  Elsmore::VERSION
  s.authors     = ["Cristiano Betta", "Mike Elsmore"]
  s.email       = ['cbetta@gmail.com']
  s.homepage    = "http://github.com/cbetta/elsmore"
  s.summary     = "Backup tool for Hackference"
  s.description = "Backup tool for Hackference"
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake')

  s.add_dependency('commander')
  s.add_dependency('httparty')
  s.add_dependency('oga')
  s.add_dependency('awesome_print')
  s.add_dependency('colorize')
end
