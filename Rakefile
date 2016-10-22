require "bundler/gem_tasks"
require 'rake/testtask'

task :console do
  exec "irb -r elsmore -I ./lib"
end

task :bin do
  ARGV.shift
  exec "ruby -Ilib ./bin/elsmore #{ARGV.join(' ')}"
end
