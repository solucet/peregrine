module Peregrine
  module Handlers
    # This module provides methods which allow Component objects to be wrapped 
    # and unwrapped for use by an instance of the Package class.
    module ComponentPackage
      # Returns +true+ if this package handler can +wrap+ and +unwrap+ the given
      # object, +false+ otherwise.
      def self.handles?(object)
        if object.class == Class
          object.ancestors.include?(Peregrine::Component)
        else
          object.kind_of?(Peregrine::Component)
        end
      end
      
      # Wraps the given Component into a generic hash.
      def self.wrap(component)
        return nil unless handles?(component)
        { :name => component.name,
          :tags => component.tags,
          :type => component.class }
      end
      
      # Unwraps a generic hash into a newly instanced Component.
      def self.unwrap(hash)
        return nil unless handles?(hash[:type])
        hash[:type].new do |component|
          component.name = hash[:name]
          component.add_tags(*hash[:tags])
        end
      end
    end
  end
end