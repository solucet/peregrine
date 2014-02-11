require 'peregrine/collections/common'
require 'peregrine/features'
require 'securerandom'

module Peregrine
  # == Summary
  # 
  # An Entity is any object within your project -- literally almost anything.
  # Entities are designed to hold Component objects which determine what the
  # Entity contains in terms of data. Components are also regularly used to
  # "flag" an Entity -- for example, adding an empty Component +Renderable+
  # would flag to System objects that this Entity can be rendered.
  # 
  # Essentially, Entity objects are little more than an identifier which serves
  # as storage for Component objects. They do nothing more than store
  # Components and provide methods for adding, removing, and filtering the
  # contained Components.
  # 
  # == Usage
  # 
  # In general, it's best not to use Entity objects directly, but to make use
  # of EntityManager objects which serve to organize and manage collections of
  # Entity instances. See the EntityManager class' documentation for more
  # information on how to use them.
  class Entity
    include Features
    
    # Array of Component objects attached to this Entity.
    attr_reader :components
    
    # Symbol representing the UUID of this Entity.
    attr_reader :uuid
    
    # Creates a new Entity instance and adds the given Component constants or
    # instances to the Entity. Yields the newly created Entity if a block is
    # given.
    # 
    # ==== Example
    # 
    #    Peregrine::Entity.new(Peregrine::Component) do |instance|
    #      # Entity names are optional, but let's name this one.
    #      instance.name = 'Example'
    #    end # => Entity 'Example' 0xdf7258 (1)
    def initialize(*components)
      @components = [].extend(Collections::Common)
      @uuid       = SecureRandom.uuid.to_sym
      add_components(*components)
      yield self if block_given?
    end
    
    # Adds the given Component constants or instances to this Entity. Constants
    # given are automatically instanced. Ignores Component classes which are 
    # already present in the Entity. Returns the array of Component objects
    # attached to this Entity after all additions.
    # 
    # ==== Example
    # 
    #    class Example < Peregrine::Component ; end
    #    
    #    entity = Peregrine::Entity.new
    #    entity.add_components(Example) # => [Component 'Example' ...]
    def add_components(*components)
      components.each do |component|
        component = component.new if component.class == Class
        unless component_classes.include?(component.class)
          @components.push(component)
        end
      end
      @components
    end
    alias :add_component :add_components
    
    # Removes Component objects of the given classes from the Entity. Returns an
    # array of the removed Component objects.
    def remove_components!(*components)
      removed = []
      components.each do |flag|
        @components.reject! { |c| c.class == flag ? removed.push(c) : false }
      end
      removed.extend(Collections::Common)
    end
    alias :remove_component! :remove_components!
    
    # Returns an array of all Component classes attached to this Entity. Yields
    # the Component classes if a block is given.
    def component_classes
      components = @components.map { |component| component.class }.uniq
      components.each { |component| yield component } if block_given?
      components.extend(Collections::Common)
    end
    
    # Returns all of the Component objects attached to this Entity of the exact
    # given class. Yields the Component objects if a block is given.
    # 
    # ==== Example
    # 
    #    class Example < Peregrine::Component ; end
    #    
    #    entity = Peregrine::Entity.new(Example)
    #    entity.components_of_class(Example) # => [Component 'Example' ...]
    def components_of_class(const)
      components = @components.select { |c| c.class == const }
      components.each { |component| yield component } if block_given?
      components.extend(Collections::Common)
    end
    
    # Returns all of the Component objects attached to this Entity descended
    # from the given class or module. Yields the Component objects if a block is
    # given.
    # 
    # ==== Example
    # 
    #    class Example < Peregrine::Component ; end
    #    
    #    entity = Peregrine::Entity.new(Peregrine::Component, Example)
    #    entity.components_of_kind(Peregrine::Component)
    #      # => [Component 'Peregrine::Component' ..., Component 'Example' ...]
    def components_of_kind(const)
      components = @components.select { |c| c.class.ancestors.include?(const) }
      components.each { |component| yield component } if block_given?
      components.extend(Collections::Common)
    end
    
    # Presents a human-readable summary of the Entity.
    def to_s
      "Entity '#{name}' #{uuid} (#{@components.size})"
    end
    alias :inspect :to_s
  end
end
