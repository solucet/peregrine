module Peregrine
  module Handlers
    # This module provides methods which allow Entity objects to be wrapped and
    # unwrapped for use by an instance of the Package class.
    module EntityPackage
      # Returns +true+ if this package handler can +wrap+ and +unwrap+ the given
      # object, +false+ otherwise.
      def self.handles?(object)
        if object.class == Class
          object.ancestors.include?(Peregrine::Entity)
        else
          object.kind_of?(Peregrine::Entity)
        end
      end
      
      # Wraps the given Entity into a generic hash.
      def self.wrap(entity)
        return nil unless handles?(entity)
        { :data => entity.components,
          :name => entity.name,
          :tags => entity.tags,
          :type => entity.class }
      end
      
      # Unwraps a generic hash into a newly instanced Entity.
      def self.unwrap(hash)
        return nil unless handles?(hash[:type])
        hash[:type].new(*hash[:data]) do |entity|
          entity.name = hash[:name]
          entity.add_tags(*hash[:tags])
        end
      end
    end
  end
end