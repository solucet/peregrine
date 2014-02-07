require 'spec_helper'

describe Peregrine::System do
  let(:manager)          { Peregrine::EntityManager.new }
  let(:system)           { Peregrine::System }
  let(:prepared_manager) do
    prepared = Peregrine::EntityManager.new
    prepared.entities.push(:test, true, false, nil)
    prepared
  end
  
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(system.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    it 'adds itself to given valid managers' do
      sys = system.new(manager)
      expect(manager.systems).to include sys
    end
    
    it 'skips adding itself to invalid managers' do
      expect { system.new(:test) }.not_to raise_error
    end
    
    it 'is enabled by default' do
      expect(subject.enabled?).to be true
    end
    
    context 'when given a block' do
      it 'yields the newly instanced System' do
        instance = nil
        expect(system.new { |s| instance = s }).to be instance
      end
    end
  end
  
  describe '#selector' do
    it 'returns a Proc object' do
      expect(subject.selector).to be_an_instance_of Proc
    end
    
    context 'used with Array#select' do
      it 'selects truth-y items' do
        array = [:test, true, false, nil]
        expect(array.select!(&subject.selector)).to eq [:test, true]
      end
    end
  end
  
  describe '#entities' do
    it 'returns Entity objects that pass through #selector' do
      prepared_manager.add_system(subject)
      expect(subject.entities).to eq [:test, true]
    end
  end
  
  describe '#enabled?' do
    it 'returns true if System is enabled' do
      subject.enable
      expect(subject.enabled?).to be true
    end
    
    it 'returns false if System is disabled' do
      subject.disable
      expect(subject.enabled?).to be false
    end
  end
  
  describe '#update' do
    it 'raises NotImplementedError' do
      subject.enable
      expect { subject.update }.to raise_error(NotImplementedError)
    end
  end
end
