require "bundler/gem_tasks"
require 'rake/testtask'

task :console do
  exec "irb -r snapshotify -I ./lib"
end

task "dev:snap", [:site] do |t, args|
  exec "ruby -Ilib/ bin/snapshotify https://#{args[:site]} --debug --trace"
end

task "dev:serve", [:site] do |t, args|
  exec "ruby -Ilib/ bin/snapshotify serve #{args[:site]}"
end
