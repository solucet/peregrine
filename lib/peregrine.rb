# Require all Ruby files in the 'peregrine/' directory. Using +File.join+ to
# ensure that all files are properly required regardless of the directory
# separator in use.
Dir[File.join(File.dirname(__FILE__), 'peregrine', '*.rb')].each do |file|
  require file
end
