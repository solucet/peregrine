require 'spec_helper'

describe Peregrine::Handlers::EntityPackage do
  describe '.handles?' do
    context 'given valid argument' do
      it 'returns true given a kind of Entity' do
        expect(subject.handles?(Peregrine::Entity.new)).to be true
      end
    
      it 'returns true given a constant with Entity ancestry' do
        expect(subject.handles?(Peregrine::Entity)).to be true
      end
    end
    
    context 'given invalid argument' do
      it 'returns false' do
        expect(subject.handles?(:entity)).to be false
      end
    end
  end
  
  describe '.wrap' do
    context 'given valid argument' do
      it 'converts instanced object data to hash' do
        expectation = { :data => [],
                        :name => 'Test',
                        :tags => [:test],
                        :type => Peregrine::Entity }
        entity = Peregrine::Entity.new { |e| e.name = 'Test'; e.add_tag(:test) }
        expect(subject.wrap(entity)).to eql expectation
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.wrap(:entity)).to be nil
      end
    end
  end
  
  describe '.unwrap' do
    context 'given valid argument' do
      it 'instantiates a new Entity' do
        data = subject.wrap(Peregrine::Entity.new)
        expect(subject.unwrap(data)).to be_an_instance_of(Peregrine::Entity)
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.unwrap({type: :entity})).to be nil
      end
    end
  end
end