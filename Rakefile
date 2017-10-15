require "bundler/gem_tasks"
require 'rake/testtask'

task :console do
  exec "irb -r snapshotify -I ./lib"
end

task "dev:snap" do
  exec "ruby -Ilib/ bin/snapshotify https://betta.io --debug --trace"
end

task "dev:serve" do
  exec "ruby -Ilib/ bin/snapshotify serve betta.io"
end
