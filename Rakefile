$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "microcon/version"

task default: [:spec]

task :build do
  system "gem build microcon.gemspec"
end

task :release => :build do
  system "gem push microcon-#{Microcon::VERSION}.gem"
end
