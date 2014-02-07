module Peregrine
  module Collections
    # Provides methods for filtering collections by item names. This module is
    # intended to be an extension to existing collection instances.
    module Named
      # Returns an array of all items with a name that matches the given
      # matcher. The matcher may be a Regexp for fine-tuned matching or any
      # other object for specific equality matching. Yields the matching items
      # in the collection if a block is given.
      # 
      # ==== Examples
      # 
      # Using a regular expression as a matcher:
      #     manager = Peregrine::EntityManager.new do |manager|
      #       manager.spawn { |entity| entity.name = 'Example' }
      #     end
      #     manager.entities.named(/^Ex/) # => [ Entity 'Example' ... ]
      # 
      # Using a string as a matcher:
      #     manager = Peregrine::EntityManager.new do |manager|
      #       manager.spawn { |entity| entity.name = 'Example' }
      #     end
      #     manager.entities.named('Example') # => [ Entity 'Example' ... ]
      def named(matcher)
        items = select do |item|
          next unless item.respond_to?(:name)
          matcher.is_a?(Regexp) ? item.name[matcher] : item.name == matcher.to_s
        end
        items.each { |item| yield item } if block_given?
        items.extend(Collections)
      end
    end
  end
end
