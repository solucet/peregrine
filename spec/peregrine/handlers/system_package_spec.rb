require 'spec_helper'

describe Peregrine::Handlers::SystemPackage do
  describe '.handles?' do
    context 'given valid argument' do
      it 'returns true given a kind of System' do
        expect(subject.handles?(Peregrine::System.new)).to be true
      end
    
      it 'returns true given a constant with System ancestry' do
        expect(subject.handles?(Peregrine::System)).to be true
      end
    end
    
    context 'given invalid argument' do
      it 'returns false' do
        expect(subject.handles?(:system)).to be false
      end
    end
  end
  
  describe '.wrap' do
    context 'given valid argument' do
      it 'converts instanced object data to hash' do
        expectation = { :name   => 'Test',
                        :status => true,
                        :tags   => [:test],
                        :type   => Peregrine::System }
        system = Peregrine::System.new { |s| s.name = 'Test'; s.add_tag(:test) }
        expect(subject.wrap(system)).to eql expectation
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.wrap(:system)).to be nil
      end
    end
  end
  
  describe '.unwrap' do
    context 'given valid argument' do
      it 'instantiates a new System' do
        data = subject.wrap(Peregrine::System.new)
        expect(subject.unwrap(data)).to be_an_instance_of(Peregrine::System)
      end
    end
    
    context 'given invalid argument' do
      it 'returns nil' do
        expect(subject.unwrap({type: :system})).to be nil
      end
    end
  end
end