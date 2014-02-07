# Require all Ruby files in the 'collections/' directory. Using +File.join+ to
# ensure that all files are properly required regardless of the directory
# separator in use.
Dir[File.join(File.dirname(__FILE__), 'collections', '*.rb')].each do |file|
  require file
end

module Peregrine
  # This module provides modules which define instance methods to be used by
  # collections (such as arrays or hashes) with methods for filtering thier
  # collected items. These modules are designed to be extensions to instances of
  # collections so as not to pollute the default Ruby collections.
  # 
  # Note that arrays returned from any of these modules are already extended
  # with all of the defined collection modules, facilitating chaining of
  # collection filtering methods.
  module Collections
    # Extends all of the constants defined within this module to the parent
    # which is extended by this module -- essentially a shortcut to extend with
    # all of the defined collections.
    def self.extended(parent)
      parent.send(:extend, *constants.map { |const| const_get(const) })
    end
  end
end
