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
	gem.name = "sex_it_up"
	gem.summary = %Q{Replace your boring place-holder images with beautiful public domain images of history's greatest artwork and sculptures.}
	gem.description = %Q{TODO: longer description of your gem}
	gem.email = "jjones@aantix.com"
	gem.homepage = "http://github.com/aantix/sex_it_up"
	gem.authors = ["Jim Jones"]
	gem.add_development_dependency "paperclip", ">= 2.3.5"
	gem.add_development_dependency "mechanize", ">= 1.0.0"
	gem.add_development_dependency "google-search", ">= 1.0.2"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "test-gem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
