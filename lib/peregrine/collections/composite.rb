module Peregrine
  module Collections
    # Provides methods for filtering Entity objects contained in a collection.
    # This module is intended to be an extension to existing collection
    # instances.
    module Composite
      # Returns an array of all Entities in the collection which include all of
      # the given Component classes. Yields the matching Entity instances if a
      # block is given.
      def with_components(*list)
        entities = select do |item|
          next unless item.respond_to?(:component_classes)
          list.all? { |component| item.component_classes.include?(component) }
        end
        entities.each { |entity| yield entity } if block_given?
        entities.extend(Collections)
      end
      alias :with_component :with_components
      
      # Returns an array of all Entities in the collection which include _any_
      # of the given Component classes. Yields the matching Entity instances if
      # a block is given.
      def with_any_component(*list)
        entities = select do |item|
          next unless item.respond_to?(:component_classes)
          !(item.component_classes & list).empty?
        end
        entities.each { |entity| yield entity } if block_given?
        entities.extend(Collections)
      end
    end
  end
end
