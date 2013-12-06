# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "MIAConverter"
  gem.homepage = "http://github.com/MartinJNash/MIAConverter"
  gem.license = "MIT"
  gem.summary = %Q{Turns a video file into an animated gif.}
  gem.description = %Q{Turns a video file into an animated gif.}
  gem.email = "martin.j.nash@gmail.com"
  gem.authors = ["Martin Nash"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new






####################
##
## TESTING
##
####################

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec




####################
##
## DOCUMENTATION
##
####################

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "MIAConverter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
