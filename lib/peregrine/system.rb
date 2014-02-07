require 'peregrine/collections'
require 'peregrine/features'

module Peregrine
  # == Summary
  # 
  # The System class implements logic for a collection of Entity objects and
  # resides within an EntityManager instance. The System class present in the
  # Peregrine framework serves as a basis for creating subclasses to implement
  # logic and perform no such logic themselves (in fact, they raise a
  # +NotImplementedError+ when updated).
  # 
  # == Usage
  # 
  # The default System class is very minimal and performs no actual logic on its
  # own. Individual developers are intended to subclass the System and implement
  # the needed logic in their own +update+ methods.
  # 
  # In addition to this, System classes may be enabled or disabled. Disabled
  # System classes may still be explicitly updated by calling their +update+
  # method, but will not automatically fire when the EntityManager that they
  # belong to calls its +update+ method. Systems are enabled by default, but may
  # be disabled when instanced by passing a block or calling the +configure+
  # method with a block.
  # 
  # Most System classes are expected to operate on a limited subset of the
  # available Entity objects within the EntityManager that contains the System.
  # As such, the +selector+ method has been provided to allow filtering the
  # EntityManager's managed Entity objects. The +selector+ method returns a
  # Proc object which is used by the +select+ method on the +entities+ array
  # owned by the EntityManager. When overwritten, the +selector+ method ensures
  # that the +entities+ method of the System only returns Entity objects that
  # pass through the +selector+ method's block.
  # 
  # Given the implementation of the +selector+, it is _highly_ recommended that
  # your wrap your System's +update+ methods in the +entities+ method to make
  # sure that they only implement logic for the properly selected Entities.
  # 
  # == Example
  # 
  # To demonstrate how to write a System subclass, we'll build a simple System
  # that simply acts on Entity objects that contain Components and removes the
  # Components each update.
  # 
  #    class Remover < Peregrine::System
  #      def selector
  #        ->(entity) { !entity.components.empty? }
  #      end
  #      
  #      def update
  #        entities.each do |entity|
  #          entity.remove_components!(*entity.component_classes)
  #        end
  #      end
  #    end
  # 
  # Now we'll create a new, disabled instance of the Remover System.
  # 
  #    manager = Peregrine::EntityManager.new
  #    manager.add_system(Remover.new { |system| system.disable })
  class System
    include Features
    
    # The EntityManager object using this System instance.
    attr_accessor :manager
    
    # Creates a new System instance operating within the given EntityManager
    # and automatically adds the System to the EntityManager. Yields the newly
    # created System if a block is given.
    # 
    # ==== Example
    # 
    #    manager = Peregrine::EntityManager.new { |m| m.name = 'Example' }
    #    Peregrine::System.new(manager) do |system|
    #      system.name = 'Example'
    #      # Systems are enabled by default, but we want this one disabled.
    #      system.disable
    #    end # => - System 'Example' 0x1724d80 <Entity Manager 'Example' ...>
    def initialize(manager = nil)
      @enabled = true
      @manager = manager
      @manager.systems.push(self) if @manager.respond_to?(:systems)
      yield self if block_given?
    end
    
    # Provides the block to be given to the +entities+ method's +select+ call
    # used to filter the Entity objects affected by the System. The default
    # +selector+ implementation returns all Entity objects that are not +false+
    # or +nil+. Intended to be overwritten in subclasses.
    def selector
      Proc.new { |entity| entity }
    end
    
    # Returns an array of all of the Entity objects that this System should act
    # upon. This method is intended to be used in the body of a subclass'
    # +update+ method in order to facilitate only operating on the desired
    # Entity objects. Entity objects are collected by calling +select+ on the
    # EntityManager's +entities+ array with a block supplied by the System's
    # +selector+ method. Yields each selected Entity object if a block is given.
    def entities
      return [] unless @manager.respond_to?(:entities)
      @manager.entities.select(&selector).each do |entity|
        yield entity if block_given?
      end
    end
    
    # Explicitly enables the System.
    def enable() @enabled = true end
    
    # Explicitly disables the System.
    def disable() @enabled = false end
    
    # Explicitly returns +true+ if the System is enabled, +false+ otherwise.
    def enabled?() @enabled ? true : false end
    
    # Called whenever the EntityManager with this System is updated. This method
    # is intended to be overwritten in subclasses by developers in order to
    # implement logic. Only called by the EntityManager if the System is
    # enabled.  Raises a +NotImplementedError+ by default.
    def update() raise NotImplementedError end
    
    # Presents a human-readable summary of the System.
    def to_s
      status = enabled? ? '+' : '-'
      "#{status} System '#{name}' #{id} <#{manager.name} #{manager.id}>"
    end
    alias :inspect :to_s
  end
end
