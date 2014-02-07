# Require all Ruby files in the 'features/' directory. Using +File.join+ to
# ensure that all files are properly required regardless of the directory
# separator in use.
Dir[File.join(File.dirname(__FILE__), 'features', '*.rb')].each do |file|
  require file
end

module Peregrine
  # This module provides modules which add instance methods to Peregrine objects
  # that provide functionality such as tags, names, and identifiers. These
  # modules are designed to be included in Peregrine classes.
  module Features
    # Includes all of the constants defined within this module to the parent
    # which includes this module -- essentially a shortcut to include all of the
    # defined features.
    def self.included(parent)
      parent.send(:include, *constants.map { |const| const_get(const) })
    end
  end
end
