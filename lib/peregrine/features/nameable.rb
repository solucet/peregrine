module Peregrine
  module Features
    # Provides methods for naming objects. Intended to be included in classes
    # requiring this functionality.
    module Nameable
      # Returns the name of the object. Lazily evaluated.
      def name
        @name ||= self.class.to_s
      end
      
      # Sets the name of the object to the given value after String coercion.
      def name=(value)
        @name = value.to_s
      end
    end
  end
end
