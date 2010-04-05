require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "census"
    gem.summary     = %Q{Rails user demographics collection and searching}
    gem.description = %Q{Census is a Rails plugin that collects searchable demographics data for each of your application's users.}
    gem.email       = "mark@envylabs.com"
    gem.homepage    = "http://github.com/envylabs/census"
    gem.authors     = ["Mark Kendall"]
    gem.files       = FileList["[A-Z]*", "{app,config,generators,lib,shoulda_macros,rails}/**/*"]
    
    gem.add_dependency "acts_as_list", ">= 0.1.2"
    gem.add_dependency "inverse_of", ">= 0.0.1"
    
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "factory_girl", ">= 0"    
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

namespace :test do
  Rake::TestTask.new(:basic => ["check_dependencies",
                                "generator:cleanup",
                                "generator:census"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.pattern = "test/{controllers,models}/*_test.rb"
    task.verbose = false
  end
end

task :default => ['test:basic']

generators = %w(census)

namespace :generator do
  desc "Cleans up the test app before running the generator"
  task :cleanup do
    FileList["test/rails_root/db/**/*"].each do |each|
      FileUtils.rm_rf(each)
    end
    
    FileUtils.rm_rf("test/rails_root/vendor/plugins/census")
    FileUtils.mkdir_p("test/rails_root/vendor/plugins")
    census_root = File.expand_path(File.dirname(__FILE__))
    system("ln -s \"#{census_root}\" test/rails_root/vendor/plugins/census")
  end
  
  desc "Run the census generator"
  task :census do
    system "cd test/rails_root && ./script/generate census -f && rake gems:unpack && rake db:migrate db:test:prepare"
  end
  
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "Census #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
