module Peregrine
  module Collections
    # Provides methods for filtering collections by item tags. This module is
    # intended to be an extension to existing collection instances.
    module Tagged
      # Returns an array of objects within this collection with all of the given
      # tags. Yields the tagged items in the collection if a block is given.
      def tagged(*list)
        items = select do |item|
          next unless item.respond_to?(:tags)
          list.all? { |tag| item.tags.include?(tag) }
        end
        items.each { |item| yield item } if block_given?
        items.extend(Collections)
      end
      
      # Returns an array of objects within this collection that contain any of
      # the given tags. Yields the tagged items in the collection if a block is
      # given.
      def any_tagged(*list)
        items = select do |item|
          next unless item.respond_to?(:tags)
          !(item.tags & list).empty?
        end
        items.each { |item| yield item } if block_given?
        items.extend(Collections)
      end
      
      # Returns an array of objects in this collection which are not tagged.
      # Yields the untagged items in the collection if a block is given.
      def untagged
        items = select { |i| i.respond_to?(:tags) ? i.tags.empty? : true }
        items.each { |item| yield item } if block_given?
        items.extend(Collections)
      end
    end
  end
end
