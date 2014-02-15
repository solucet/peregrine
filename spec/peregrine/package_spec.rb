require 'spec_helper'

describe Peregrine::Package do
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(described_class.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    it 'instantiates with default handlers' do
      handlers = [ Peregrine::Handlers::ComponentPackage,
                   Peregrine::Handlers::EntityPackage,
                   Peregrine::Handlers::SystemPackage ]
      expect(subject.handlers).to eql handlers
    end
    
    context 'given arguments' do
      it 'wraps given objects' do
        expectation = [ Peregrine::Entity, Peregrine::System ]
        pkg = described_class.new(Peregrine::Entity.new, Peregrine::System.new)
        expect(pkg.archive.map { |h, p| h[:type] }).to eql expectation
      end
    end
    
    context 'given a block' do
      it 'yields the newly created Package' do
        instance = nil
        expect(described_class.new { |em| instance = em }).to be instance
      end
    end
  end
  
  describe '#wrap' do
    context 'given valid arguments' do
      it 'wraps given objects' do
        expectation = [ Peregrine::Entity, Peregrine::System ]
        subject.wrap(Peregrine::Entity.new, Peregrine::System.new)
        expect(subject.archive.map { |h, p| h[:type] }).to eql expectation
      end
    end
    
    context 'given invalid arguments' do
      it 'ignores given objects' do
        expectation = [ Peregrine::Entity ]
        subject.wrap(Peregrine::Entity.new, :invalid)
        expect(subject.archive.map { |h, p| h[:type] }).to eql expectation
      end
    end
  end
  
  describe '#unwrap' do
    it 'returns an array of new instantiated objects' do
      original = Peregrine::Entity.new
      subject.wrap(original)
      expect(subject.unwrap).to be_kind_of(Array)
      expect(subject.unwrap).not_to eql [original]
    end
    
    context 'when given a block' do
      it 'yields each unwrapped item' do
        subject.wrap(Peregrine::Entity.new { |e| e.name = 'Test' })
        name = nil
        subject.unwrap { |i| name = i.name }
        expect(name).to eql 'Test'
      end
    end
  end
end