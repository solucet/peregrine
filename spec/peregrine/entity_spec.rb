require 'spec_helper'

class TestComponent < Peregrine::Component ; end

describe Peregrine::Entity do
  let(:component)       { Peregrine::Component }
  let(:entity)          { Peregrine::Entity }
  let(:prepared_entity) { Peregrine::Entity.new(component, TestComponent) }
  
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(entity.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    context 'with arguments' do
      it 'instantiates with given Components' do
        expect(prepared_entity.component_classes).to include component
      end
    end
    
    context 'without arguments' do
      it 'instantiates without any Components' do
        expect(subject.components).to be_empty
      end
    end
    
    context 'with a block' do
      it 'yields the newly instanced Entity' do
        instance = nil
        expect(entity.new { |e| instance = e }).to be instance
      end
    end
  end
  
  describe '@components' do
    it 'is extended with Peregrine::Collections::Common' do
      extensions = subject.components.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
    end
  end
  
  describe '#add_components' do
    let(:component_instance) { component.new(:parent) }
    
    it 'adds the given Component constants' do
      subject.add_components(component)
      expect(subject.components.first.class).to be component
    end
    
    #it 'updates Component parents when given existing instances' do
    #  subject.add_components(component_instance)
    #  expect(subject.components.first.parent).to be subject
    #end
    
    it 'ignores Components already present' do
      expect(prepared_entity.add_components(component).size).to be 2
    end
    
    it 'returns all Components in the Entity' do
      expect(subject.add_components(component)).to eql subject.components
    end
  end
  
  describe '#remove_components!' do
    it 'removes the given Components' do
      removed = prepared_entity.remove_components!(component).first
      expect(prepared_entity.components).not_to include removed
    end
    
    it 'returns an array of removed Components' do
      array = prepared_entity.components_of_class(component)
      expect(prepared_entity.remove_components!(component)).to eql array
    end
    
    it 'returns an array extended with Peregrine::Collections::Common' do
      return_value = prepared_entity.remove_components!(component)
      extensions = return_value.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
    end
  end
  
  describe '#component_classes' do
    it 'returns the included Component classes' do
      expect(prepared_entity.component_classes).to eq [component, TestComponent]
    end
    
    it 'returns an array extended with Peregrine::Collections::Common' do
      return_value = prepared_entity.component_classes
      extensions = return_value.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
    end
    
    context 'when given a block' do
      it 'yields each included Component class' do
        expectation = []
        prepared_entity.component_classes do |component|
          expectation << component
        end
        expect(expectation).to eql prepared_entity.component_classes
      end
    end
  end
  
  describe '#components_of_class' do
    it 'returns Components of the exact given class' do
      expect(subject.components_of_class(component)).to be_empty
      expect(prepared_entity.components_of_class(component).size).to be 1
    end
    
    it 'returns an array extended with Peregrine::Collections::Common' do
      return_value = prepared_entity.components_of_class(component)
      extensions = return_value.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
    end
    
    context 'when given a block' do
      it 'yields each Component of the given class' do
        expectation = []
        prepared_entity.components_of_class(component).each do |component|
          expectation << component
        end
        expect(expectation).to eq prepared_entity.components_of_class(component)
      end
    end
  end
  
  describe '#components_of_kind' do
    it 'returns Components with the given ancestor' do
      expect(subject.components_of_kind(component)).to be_empty
      expect(prepared_entity.components_of_kind(component).size).to be 2
    end
    
    it 'returns an array extended with Peregrine::Collections::Common' do
      return_value = prepared_entity.components_of_kind(component)
      extensions = return_value.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections::Common
    end
    
    context 'when given a block' do
      it 'yields each Component with the given ancestor' do
        expectation = []
        prepared_entity.components_of_kind(component).each do |component|
          expectation << component
        end
        expect(expectation).to eql prepared_entity.components_of_kind(component)
      end
    end
  end
end
