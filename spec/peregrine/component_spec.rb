require 'spec_helper'

describe Peregrine::Component do
  let(:component) { Peregrine::Component }
  let(:entity)    { Peregrine::Entity.new }
  
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(component.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    context 'without arguments' do
      it 'initializes with a nil parent' do
        expect(subject.parent).to be nil
      end
    end
    
    context 'with arguments' do
      it 'initializes with the given parent' do
        expect(component.new(:parent).parent).to be :parent
      end
      
      it 'adds itself to parent if parent responds to #add_component' do
        component.new(entity)
        expect(entity.component_classes).to include component
      end
    end
    
    context 'with block' do
      it 'yields the newly instanced Component' do
        instance = nil
        expect(component.new { |c| instance = c }).to be instance
      end
    end
  end
  
  describe '#change_parent' do
    it 'removes the Component from its previous parent' do
      c = component.new(entity)
      c.change_parent(:parent)
      expect(entity.components).to be_empty
    end
    
    it 'adds the Component to its new parent' do
      c = component.new(:parent)
      c.change_parent(entity)
      expect(c.parent).to be entity
    end
  end
  
  describe '#remove_parent!' do
    it 'removes the current parent' do
      c = component.new(:parent)
      c.remove_parent!
      expect(c.parent).to be nil
    end
    
    context 'with Entity as parent' do
      it 'removes the Component from the Entity' do
        entity.add_component(c = component.new)
        c.remove_parent!
        expect(entity.components).to be_empty
      end
    end
  end
end
