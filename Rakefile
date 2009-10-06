require 'rubygems'
require 'rake'
require 'rake/clean'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rbkb-http"
    gem.summary = %Q{HTTP add-ons for Ruby BlackBag}
    gem.description = %Q{HTTP libraries and tools based on and complementary to Ruby BlackBag}
    gem.email = "emonti@matasano.com"
    gem.homepage = "http://github.com/emonti/rbkb-http"
    gem.authors = ["Eric Monti"]
    gem.add_development_dependency "rspec"
    gem.add_dependency "rbkb"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask' 
Rake::TestTask.new(:test) do |test| 
  test.libs << 'lib' << 'test' 
  test.pattern = 'test/**/test_*.rb' 
  test.verbose = true 
end 
 
begin 
  require 'rcov/rcovtask' 
  Rcov::RcovTask.new do |test| 
    test.libs << 'test' 
    test.pattern = 'test/**/*_test.rb' 
    test.verbose = true 
  end 
rescue LoadError 
  task :rcov do 
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov" 
  end 
end

#require 'spec/rake/spectask'
#Spec::Rake::SpecTask.new(:spec) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.spec_files = FileList['spec/**/*_spec.rb']
#end
#
#Spec::Rake::SpecTask.new(:rcov) do |spec|
#  spec.libs << 'lib' << 'spec'
#  spec.pattern = 'spec/**/*_spec.rb'
#  spec.rcov = true
#end

#task :spec => :check_dependencies

#task :default => :spec
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rbkb-http #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

