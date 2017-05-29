require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ready_for_i18n"
    gem.summary = "ready_for_i18n is a tool helping for the very first step of transfering your local Rails project to an i18n one."
    gem.description = <<END_OF_DESC
      ready_for_i18n will help you extract visible hard-coded text from your ERB view files,
      then choose a proper key and replace them with the I18n.translate method like t(:login)
END_OF_DESC
    
    gem.email = "zigzag.chen@gmail.com"
    gem.homepage = "http://github.com/zigzag/ready_for_i18n"
    gem.authors = ["zigzag"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_dependency("ya2yaml", [">= 0.26"])
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
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
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

begin
  require 'rake/rdoctask'
  Rake::RDocTask.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "ready_for_i18n #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
rescue LoadError
 task :rdoc do
    abort "Rdoc is not available. In order to run rdoc, you must: sudo gem install rdoc"
  end
end

