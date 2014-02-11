require 'peregrine/features'

module Peregrine
  # == Summary
  # 
  # Components serve as data storage for Entity objects. Component objects, by
  # definition, should _not_ contain any logic -- they serve only as a way to
  # store information or as a "flag" for an Entity to be used by a System to
  # implement the actual logic.
  # 
  # == Usage
  # 
  # It is expected that developers will subclass the Component class in order
  # to create their own individual Components. When subclassing the Component,
  # it is important to note that you should _not_ overwrite the +#initialize+
  # method, and instead overwite the +#initialize_data+ method in order to
  # instantiate a Component. Any additional arguments given to +Component.new+
  # are passed along to the +#initialize_data+ method.
  # 
  # == Example
  # 
  #    class Mortal < Peregrine::Component
  #      attr_reader :health
  #      
  #      # Initializing the data for this Component object.
  #      def initialize_data(health = 100, max_health = 100)
  #        @health  = health
  #        @maximum = max_health
  #      end
  #      
  #      # Do not implement logic, but define limits for data storage.
  #      def health=(value)
  #        @health = [0, value, @maximum].sort[1]
  #      end
  #    end
  class Component
    include Features
    
    # Create a new Component instance. Any arguments given to this method are 
    # passed to the +initialize_data+ method. Yields the newly instanced
    # Component if a block is given.
    def initialize(*data_args)
      initialize_data(*data_args)
      yield self if block_given?
    end
    
    # Intended to be overwritten by subclasses of the Component to initialize
    # the data used. Additional arguments passed to +Component.new+ are passed
    # to this method directly. This method does nothing on its own.
    def initialize_data
    end
    
    # Presents a human-readable summary of the Component.
    def to_s
      "Component '#{name}' #{id}"
    end
    alias :inspect :to_s
  end
end
