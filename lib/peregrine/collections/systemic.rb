module Peregrine
  module Collections
    # Provides methods for filtering System objects contained in a collection.
    # This module is intended to be an extension to existing collection
    # instances.
    module Systemic
      # Returns an array of enabled System objects in the collection. Yields the
      # matching System instances if a block is given.
      def enabled
        systems = select do |system|
          next unless system.respond_to?(:enabled?)
          system.enabled?
        end
        systems.each { |system| yield system } if block_given?
        systems.extend(Collections)
      end
      
      # Returns an array of disabled System objects in the collection. Yields
      # the matching System instances if a block is given.
      def disabled
        systems = select do |system|
          next unless system.respond_to?(:enabled?)
          !system.enabled?
        end
        systems.each { |system| yield system } if block_given?
        systems.extend(Collections)
      end
    end
  end
end
