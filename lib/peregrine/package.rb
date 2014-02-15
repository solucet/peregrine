require 'peregrine/features'
require 'peregrine/handlers'

module Peregrine
  # == Summary
  # 
  # A Package is essentially a fast and easy way to package multiple commonly
  # used items into an archive that can quickly recreate new instances of those
  # items. Packages are especially useful for grouping together Components and
  # Entities, and can be used to create 'templates' for instantiating objects
  # that will be used often.
  # 
  # == Usage
  # 
  # By default, a Package may contain items that are children of the Component,
  # Entity, and System classes. A single Package may contain any combination of
  # these items. Items are added to the Package with the +wrap+ method, while
  # instantiation of wrapped items is performed with the +unwrap+ method. The
  # +unwrap+ method returns an array of instantiated objects built from the
  # Package's internal archive of object data.
  # 
  # When used in conjunction with the EntityManager's +add_package+ method, the
  # Package class truly shines.
  # 
  # == Example
  # 
  # Let's assume that we're building a role-playing game and need a common
  # template for creating non-playable characters. That package may look
  # something like this:
  # 
  #    include Peregrine
  #    template = Package.new { |pkg| pkg.name = 'NPC' }
  #    template.wrap(Entity.new(Renderable, Autonomous, Conversational) do |npc|
  #      npc.name = 'Generic NPC'
  #      npc.add_tags(:npc)
  #    end)
  #    template.unwrap # => [Entity 'Generic NPC' ... (3)]
  # 
  # The newly instanced Entity generated from the package will have a different
  # ID and UUID each time it is created, but will always have the same name,
  # components, and tags.
  class Package
    include Peregrine::Features
    
    # Array of objects used to build instances for the +unwrap+ method.
    attr_reader :archive
    
    # Array of package handling modules used to facilitate wrapping and
    # unwrapping of objects.
    attr_reader :handlers
    
    # Creates a new Package instance and adds the given objects to the Package.
    # Yields the newly created Package if a block is given.
    def initialize(*objects)
      @archive  = []
      @handlers = [ Peregrine::Handlers::ComponentPackage,
                    Peregrine::Handlers::EntityPackage,
                    Peregrine::Handlers::SystemPackage ]
      wrap(*objects)
      yield self if block_given?
    end
    
    # Wraps the given objects into the Package. Returns the array of archived
    # objects in the Package.
    def wrap(*objects)
      objects.each do |object|
        @handlers.each do |handler|
          next unless handler.handles?(object)
          item = handler.wrap(object)
          @archive.push(item) unless item.nil?
        end
      end
      @archive
    end
    
    # Unwraps all objects in the package into newly instanced objects. Returns
    # the array of instanced objects. Yields each unwrapped item if a block is
    # given.
    def unwrap
      unwrapped = []
      @archive.each do |object|
        @handlers.each do |handler|
          item = handler.unwrap(object)
          unwrapped.push(item) unless item.nil?
        end
      end
      unwrapped.each { |item| yield item if block_given? }
      unwrapped
    end
    
    # Presents a human-readable summary of the Package.
    def to_s
      "Package '#{name}' #{id} (#{@archive.size})"
    end
    alias :inspect :to_s
  end
end