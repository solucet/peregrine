module Peregrine
  module Features
    # Provides methods for adding and removing tags to and from objects. This
    # essentially provides yet another method for identifying and filtering
    # various objects. Intended to be included in classes requiring this
    # functionality.
    module Taggable
      # Returns the array of tags this object contains. Lazily evaluated.
      def tags
        @tags ||= []
      end
      
      # Add the given tags to the object. Tags may be any kind of object. Tags
      # identical to existing tags are ignored. Returns an array of all tags
      # this object contains.
      def add_tags(*list)
        tags.push(*list).uniq!
        tags
      end
      alias :add_tag :add_tags
      
      # Removes the given tags from the object. Returns an array of the removed
      # tags.
      def remove_tags!(*list)
        removed = []
        tags.reject! { |tag| list.include?(tag) ? removed.push(tag) : false }
        removed
      end
      alias :remove_tag! :remove_tags!
    end
  end
end
