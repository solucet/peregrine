require 'spec_helper'

class TestComponent < Peregrine::Component ; end

describe Peregrine::Collections::Composite do
  let(:component) { Peregrine::Component }
  let(:collection) do
    [ Peregrine::Entity.new(component),
      Peregrine::Entity.new(component, TestComponent),
      Peregrine::Entity.new ].extend(subject)
  end
  
  describe '#with_components' do
    it 'returns an array of Entities with exact given Component classes' do
      expectation = collection.with_components(component, TestComponent)
      expect(expectation).to eql [collection[1]]
    end
    
    context 'when given a block' do
      it 'yields each matching Entity object' do
        expectation = []
        collection.with_components(component) do |entity|
          expectation << entity
        end
        expect(expectation).to eql collection.with_components(component)
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      singleton  = collection.with_components(component).singleton_class
      extensions = singleton.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
  
  describe '#with_any_component' do
    it 'returns an array of Entities with any of the given Component classes' do
      expectation = collection.with_any_component(component, TestComponent)
      expect(expectation).to eql collection[0..1]
    end
    
    context 'when given a block' do
      it 'yields each matching Entity object' do
        expectation = []
        collection.with_any_component(component) do |entity|
          expectation << entity
        end
        expect(expectation).to eql collection.with_any_component(component)
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      singleton  = collection.with_any_component(component).singleton_class
      extensions = singleton.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
end
