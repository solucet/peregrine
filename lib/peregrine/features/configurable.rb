module Peregrine
  module Features
    # Provides the +configure+ method. Intended to be included in classes
    # requiring this functionality.
    module Configurable
      # Yields the object this method is called on. This method is intended to
      # allow configuration of Peregrine objects with other features. Returns
      # the object this method was called on.
      # 
      # ==== Example
      # 
      #    entity = Peregrine::Entity.new
      #    entity.configure { |e| e.name = 'Example' } # => Entity 'Example' ...
      def configure
        yield self if block_given?
        self
      end
    end
  end
end
