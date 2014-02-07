require 'peregrine/collections'
require 'peregrine/entity'
require 'peregrine/features'

module Peregrine
  # == Summary
  # 
  # The EntityManager is an object designed to create, organize, and filter an
  # array of Entity objects and manage System objects which implement logic for
  # those Entities. Essentially, the EntityManager serves to group related
  # Entity objects and provide them with the Systems that act upon them.
  # 
  # == Usage
  # 
  # The EntityManager is designed to group related Entity objects with the
  # System instances which provide their logic. As such, it is recommended that
  # you utilize as many instances of EntityManager objects as your application
  # requires.
  # 
  # EntityManager objects automatically extend their arrays of Entity and System
  # objects with instance methods designed to facilitate filtering of the
  # managed items each respectively contain. Entities may be filtered by name,
  # included (or excluded) tags, and which Component classes they may or may not
  # contain. Likewise, System objects may be filtered based on any tags they do
  # or do not have as well as by name.  For more detailed information about the
  # available filtering methods, please see the documentation for the
  # Peregrine::Collections module and the modules that it contains.
  # 
  # Note that Peregrine itself does not include any objects for grouping
  # EntityManager instances together (unlike some other frameworks) -- this
  # functionality is left up to individual developers and their preferred
  # methods. Use your EntityManagers in whatever way you personally feel would
  # best benefit _you_ and _your_ application.
  # 
  # == Examples
  # 
  # Naming EntityManager instances, spawning Entity objects, and filtering
  # Entity objects based on tags:
  # 
  #    class Example < Peregrine::Component ; end
  #    
  #    manager = Peregrine::EntityManager.new { |m| m.name = 'Example' }
  #    5.times do |iterator|
  #      iterator += 1
  #      manager.spawn(Example) do |entity|
  #        entity.name = iterator
  #        iterator.even? ? entity.add_tag(:even) : entity.add_tag(:odd)
  #      end
  #    end
  #    manager.entities.tagged(:even) # => [Entity '2' ..., Entity '4' ...]
  # 
  # Finding all basic entities and adding a component to them with a block:
  # 
  #    manager = Peregrine::EntityManager.new
  #    rand(1..20).times { manager.spawn }
  #    manager.basic_entities do |entity|
  #      e.add_component(Peregrine::Component)
  #    end
  class EntityManager
    include Features
    
    # Array of entities owned by this EntityManager.
    attr_reader :entities
    
    # Array of Systems operating within this EntityManager.
    attr_reader :systems
    
    # Creates a new EntityManager instance. Yields the newly created instance if
    # a block is given.
    def initialize
      @entities = [].extend(Collections::Common, Collections::Composite)
      @systems  = [].extend(Collections::Common, Collections::Systemic)
      yield self if block_given?
    end
    
    # Calls +update+ on each enabled System within this EntityManager. The
    # +update+ method is _intended_ to be called once per 'tick,' but the actual
    # implementation is left up to the developer. Returns the array of System
    # objects operating within the EntityManager.
    def update
      @systems.each { |system| system.update if system.enabled? }
    end
    
    # Spawns a new Entity with the given Components and pushes the new Entity
    # into the array of owned entities. Returns the spawned Entity. Yields the
    # new Entity before pushing it into the owned entities array if a block is
    # given.
    def spawn(*arguments)
      entity = Peregrine::Entity.new(*arguments)
      yield entity if block_given?
      @entities.push(entity)
      entity
    end
    
    # Adds the given Entity instances (or instantiated Entity constants) to the
    # EntityManager. Returns the array of managed Entity objects.
    def add_entities(*entities)
      entities.each do |entity|
        entity = entity.new if entity.class == Class
        @entities.push(entity)
      end
      @entities
    end
    alias :add_entity :add_entities
    
    # Removes the given Entity instances from the EntityManager. Returns the
    # removed Entity objects. Intended to be used with the EntityManager's
    # filtering methods to select appropriate Entity instances.
    def remove_entities!(*entities)
      removed = []
      @entities.reject! do |entity|
        entities.include?(entity) ? removed.push(entity) : false
      end
      removed.extend(Collections::Common, Collections::Composite)
    end
    alias :remove_entity! :remove_entities!
    
    # Returns an array of all managed Entity objects without Components. Yields
    # the array of basic Entities if a block is given. Note that "basic" Entity
    # objects _may_ still be named or tagged.
    def basic_entities
      entities = @entities.select { |e| e.components.empty? }
      entities.each { |entity| yield entity } if block_given?
      entities.extend(Collections::Common, Collections::Composite)
    end
    
    # Adds the given System instances (or instantiated System constants) to the
    # EntityManager, updating the array of managers each System contains.
    # Returns the array of System objects operating in the EntityManager.
    def add_systems(*systems)
      systems.each do |system|
        if system.class == Class
          system = system.new(self)
        else
          @systems.push(system)
          system.managers.push(self).uniq!
        end
      end
      @systems
    end
    alias :add_system :add_systems
    
    # Removes the given System instances (or all System classes of the given
    # constants) from the EntityManager, updating the array of managers each
    # System contains. Returns an array of the deleted System instances.
    def remove_systems!(*systems)
      removed = []
      @systems.reject! do |system|
        if systems.include?(system) || systems.include?(system.class)
          system.managers.delete(self)
          removed.push(system)
        else false end
      end
      removed.extend(Collections::Common, Collections::Systemic)
    end
    
    # Presents a human-readable summary of the EntityManager.
    def to_s
      "Entity Manager '#{name}' #{id} " <<
      "(#{@entities.size} Entities, #{@systems.size} Systems)"
    end
    alias :inspect :to_s
  end
end
