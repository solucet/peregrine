require 'spec_helper'

class TestComponent < Peregrine::Component; end

describe Peregrine::EntityManager do
  let(:manager) { Peregrine::EntityManager }
  let(:prepared_manager) do
    Peregrine::EntityManager.new do |em|
      em.add_system(Peregrine::System)
      em.spawn
      em.spawn(Peregrine::Component)
      em.spawn(TestComponent)
      em.spawn(Peregrine::Component, TestComponent)
    end
  end
  
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(manager.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    it 'instantiates with no Entities or Systems' do
      expect(subject.entities).to be_empty
      expect(subject.systems).to be_empty
    end
    
    context 'when given a block' do
      it 'yields the newly created EntityManager' do
        instance = nil
        expect(manager.new { |em| instance = em }).to be instance
      end
    end
  end
  
  describe '@entities' do
    it 'is extended with Collections::Common and Collections::Composite' do
      extensions = subject.entities.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
      expect(extensions).to include Peregrine::Collections::Composite
    end
  end
  
  describe '@systems' do
    it 'is extended with Collections::Common and Collections::Systemic' do
      extensions = subject.systems.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
      expect(extensions).to include Peregrine::Collections::Systemic
    end
  end
  
  describe '#update' do
    it 'updates all operating System instances' do
      expect { prepared_manager.update }.to raise_error(NotImplementedError)
    end
  end
  
  describe '#spawn' do
    it 'adds a new Entity to the array of managed Entities' do
      expect(subject.entities).to be_empty
      subject.spawn
      expect(subject.entities).not_to be_empty
    end
    
    it 'passes given arguments to Entity.new' do
      subject.spawn(Peregrine::Component)
      expectation = subject.entities.first.component_classes
      expect(expectation).to eq [Peregrine::Component]
    end
    
    it 'returns the spawned Entity' do
      entity = subject.spawn
      expect(subject.entities.first).to eql entity
    end
    
    context 'when given a block' do
      it 'yields the newly created Entity' do
        instance = nil
        subject.spawn { |e| instance = e }
        expect(subject.entities).to include instance
      end
    end
  end
  
  describe '#add_entities' do
    it 'adds the given Entity instances' do
      expect(subject.entities).to be_empty
      subject.add_entities(ent = Peregrine::Entity.new)
      expect(subject.entities).to include ent
    end
    
    it 'adds instances of the given Entity constants' do
      expect(subject.entities).to be_empty
      subject.add_entities(Peregrine::Entity)
      expect(subject.entities.first.class).to be Peregrine::Entity
    end
    
    it 'returns the array of managed Entities' do
      expect(subject.add_entities(Peregrine::Entity)).to eql subject.entities
    end
  end
  
  describe '#remove_entities!' do
    it 'removes the given Entity instances' do
      ent = subject.spawn
      subject.remove_entities!(ent)
      expect(subject.entities).not_to include ent
    end
    
    it 'returns an array of removed Entities' do
      ent = subject.spawn
      expect(subject.remove_entities!(ent)).to eql [ent]
    end
    
    it 'returns an array extended with Common and Composite collections' do
      extensions = subject.remove_entities!.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
      expect(extensions).to include Peregrine::Collections::Composite
    end
  end
  
  describe '#basic_entities' do
    it 'returns an array of managed Entities without Components' do
      expect(prepared_manager.basic_entities).to be_an_instance_of Array
      prepared_manager.basic_entities.each do |basic_entity|
        expect(basic_entity.components).to be_empty
      end
    end
    
    it 'returns an array extended with Common and Composite collections' do
      extensions = subject.basic_entities.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
      expect(extensions).to include Peregrine::Collections::Composite
    end
    
    context 'when given a block' do
      it 'yields each basic Entity' do
        expectation = []
        prepared_manager.basic_entities.each { |e| expectation << e }
        expect(expectation).to eq prepared_manager.basic_entities
      end
    end
  end
  
  describe '#add_systems' do
    it 'adds the given System instances' do
      expect(subject.systems).to be_empty
      subject.add_systems(sys = Peregrine::System.new)
      expect(subject.systems).to include sys
    end
    
    it 'adds instances of the given System constants' do
      expect(subject.systems).to be_empty
      subject.add_systems(Peregrine::System)
      expect(subject.systems.first.class).to be Peregrine::System
    end
    
    it 'adds the EntityManager to each System' do
      subject.add_systems(sys = Peregrine::System.new)
      expect(sys.managers).to include subject
    end
    
    it 'returns the array of operating System instances' do
      expect(subject.add_systems(Peregrine::System)).to eql subject.systems
    end
  end
  
  describe '#remove_systems!' do
    it 'removes the given System instances' do
      expect(prepared_manager.systems).not_to be_empty
      prepared_manager.remove_systems!(prepared_manager.systems.first)
      expect(prepared_manager.systems).to be_empty
    end
    
    it 'removes instances of System classes matching the given constants' do
      expect(prepared_manager.systems).not_to be_empty
      prepared_manager.remove_systems!(Peregrine::System)
      expect(prepared_manager.systems).to be_empty
    end
    
    it 'removes the EntityManager from each System' do
      sys = Peregrine::System.new(subject)
      subject.remove_systems!(Peregrine::System)
      expect(sys.managers).to be_empty
    end
    
    it 'returns an array of removed System instances' do
      sys = prepared_manager.systems.first
      expect(prepared_manager.remove_systems!(Peregrine::System)).to eql [sys]
    end
    
    it 'returns an array extended with Common and Systemic collections' do
      extensions = subject.remove_systems!.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
      expect(extensions).to include Peregrine::Collections::Systemic
    end
  end
end
