# Adding Peregrine's 'lib/' directory to the path directly.
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peregrine/version'
require 'rake/clean'
require 'rdoc/task'

# Using `rake clean` instead of `clobber` in this project, so load up CLEAN
# appropriately. Assume that `rake clean` should leave the project in a "just
# cloned from repository" state.
files = File.readlines('.gitignore').map(&:strip).select! do |file|
  file.end_with?('/') ? File.directory?(file) : File.exist?(file)
end
CLEAN.include(*CLOBBER, *files)

# Hash of task names to replace the default RDoc tasks to match the namespacing
# used in this Rakefile.
rdoc_tasks = {
  :rdoc         => 'rdoc:build',
  :clobber_rdoc => 'rdoc:clean',
  :rerdoc       => 'rdoc:force'
}

# Configuring the RDoc tasks.
RDoc::Task.new(rdoc_tasks) do |rdoc|
  rdoc.title    = 'Peregrine Documentation'
  rdoc.main     = 'README.md'
  rdoc.rdoc_dir = 'rdoc/'
  rdoc.rdoc_files.include('README.md', 'LICENSE', 'lib/**/*.rb')
end

# Remove tasks that won't be used or will be overwritten.
Rake::Task['rdoc:clean'].clear # Overwritten
Rake::Task[:clobber].clear     # Unused

# RDoc-related task namespace.
namespace :rdoc do
  # Rewrite of `rdoc:clean` to only remove the 'rdoc/' directory if it exists.
  desc 'Remove RDoc HTML files'
  task :clean do
    rm_r('rdoc/') if File.directory?('rdoc/')
  end
end

# RSpec-related task namespace.
namespace :spec do
  desc 'Run detailed RSpec tests'
  task :nested do
    sh 'rspec spec --color --format nested'
  end
  
  desc 'Run RSpec tests (`rake` default task)'
  task :run do
    sh 'rspec spec --color'
  end
end

# Namespace related to gem building, pushing, and maintenance.
namespace :gem do
  directory 'pkg'
  
  desc 'Build .gem file in pkg/ from gemspec'
  task :build => :pkg do
    if File.exist?("pkg/peregrine-#{Peregrine::VERSION}.gem")
      puts("RubyGem already exists: pkg/peregrine-#{Peregrine::VERSION}.gem")
    else
      sh 'gem build peregrine.gemspec'
      mv "peregrine-#{Peregrine::VERSION}.gem", 'pkg/'
    end
  end
  
  desc 'Remove built gem files and pkg/ directory'
  task :clean do
    rm_r 'pkg/' if File.directory?('pkg/')
  end
  
  desc 'Build and install latest local gem'
  task :install => :build do
    sh "gem install --local pkg/peregrine-#{Peregrine::VERSION}.gem"
  end
  
  desc 'Build and push latest gem to rubygems.org'
  task :release => :build do
    sh "gem push pkg/peregrine-#{Peregrine::VERSION}"
  end
  
  desc 'Uninstall all peregrine gems'
  task :uninstall do
    sh 'gem uninstall --all peregrine'
  end
end

# Shortcut tasks.
desc 'Run gem:build task'
task :gem => 'gem:build'

desc 'Run rdoc:force task'
task :rdoc => 'rdoc:force'

desc 'Run spec:nested task'
task :spec => 'spec:nested'

# Default to quickly running RSpec tests.
task :default => 'spec:run'
