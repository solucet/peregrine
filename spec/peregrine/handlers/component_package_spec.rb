require 'spec_helper'

describe Peregrine::Handlers::ComponentPackage do
  describe '.handles?' do
    context 'given valid argument' do
      it 'returns true given a kind of Component' do
        expect(subject.handles?(Peregrine::Component.new)).to be true
      end
    
      it 'returns true given a constant with Component ancestry' do
        expect(subject.handles?(Peregrine::Component)).to be true
      end
    end
    
    context 'given invalid argument' do
      it 'returns false' do
        expect(subject.handles?(:component)).to be false
      end
    end
  end
  
  describe '.wrap' do
    context 'given valid argument' do
      it 'converts instanced object data to hash' do
        expectation = { :name => 'Test',
                        :tags => [:test],
                        :type => Peregrine::Component }
        com = Peregrine::Component.new { |c| c.name = 'Test'; c.add_tag(:test) }
        expect(subject.wrap(com)).to eql expectation
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.wrap(:component)).to be nil
      end
    end
  end
  
  describe '.unwrap' do
    context 'given valid argument' do
      it 'instantiates a new Component' do
        data = subject.wrap(Peregrine::Component.new)
        expect(subject.unwrap(data)).to be_an_instance_of(Peregrine::Component)
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.unwrap({type: :component})).to be nil
      end
    end
  end
end