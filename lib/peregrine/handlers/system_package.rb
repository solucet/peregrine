module Peregrine
  module Handlers
    # This module provides methods which allow System objects to be wrapped and
    # unwrapped for use by an instance of the Package class.
    module SystemPackage
      # Returns +true+ if this package handler can +wrap+ and +unwrap+ the given
      # object, +false+ otherwise.
      def self.handles?(object)
        if object.class == Class
          object.ancestors.include?(Peregrine::System)
        else
          object.kind_of?(Peregrine::System)
        end
      end
      
      # Wraps the given System into a generic hash.
      def self.wrap(system)
        return nil unless handles?(system)
        { :name   => system.name,
          :status => system.enabled?,
          :tags   => system.tags,
          :type   => system.class }
      end
      
      # Unwraps a generic hash into a newly instanced System.
      def self.unwrap(hash)
        return nil unless handles?(hash[:type])
        hash[:type].new do |system|
          system.name = hash[:name]
          system.disable unless hash[:status]
          system.add_tags(*hash[:tags])
        end
      end
    end
  end
end