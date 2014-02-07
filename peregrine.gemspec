# Adding Peregrine's 'lib/' directory to the path directly.
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'peregrine/version'

Gem::Specification.new do |gem|
  # Basic gem information.
  gem.name     = 'peregrine'
  gem.version  = Peregrine::VERSION
  gem.authors  = ['Kevin Owen']
  gem.email    = ['solucet@icloud.com']
  gem.homepage = 'http://github.com/solucet/peregrine'
  gem.platform = Gem::Platform::RUBY
  
  # Gem summary and description.
  gem.summary     = 'Flexible Entity-Component framework for Ruby.'
  gem.description = %{
    Peregrine is a minimal, highly adaptive Entity-Component design framework
    for the Ruby scripting language designed for general-purpose programming.
  }.gsub(/\s+/, " ").strip
  
  # Development dependencies.
  ['rake', 'rdoc', 'rspec'].each do |dependency|
    gem.add_development_dependency(dependency)
  end
  
  # File and directory information.
  gem.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  gem.require_path = 'lib'
end
