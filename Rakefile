require "bundler/gem_tasks"
require 'rake/testtask'

task :console do
  exec "irb -r snapshotify -I ./lib"
end

task :bin do
  exec "ruby -Ilib/ bin/snapshotify https://betta.io"
end
