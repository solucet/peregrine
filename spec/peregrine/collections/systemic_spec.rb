require 'spec_helper'

describe Peregrine::Collections::Systemic do
  let(:collection) do
    [ Peregrine::System.new { |s| s.enable },
      Peregrine::System.new { |s| s.disable } ].extend(subject)
  end
  
  describe '#enabled' do
    it 'returns an array of enabled items' do
      expect(collection.enabled).to eql [collection.first]
    end
    
    context 'when given a block' do
      it 'yields each enabled item' do
        expectation = []
        collection.enabled { |system| expectation << system }
        expect(expectation).to eql collection.enabled
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.enabled.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
  
  describe '#disabled' do
    it 'returns an array of disabled items' do
      expect(collection.disabled).to eql [collection.last]
    end
    
    context 'when given a block' do
      it 'yields each enabled item' do
        expectation = []
        collection.disabled { |system| expectation << system }
        expect(expectation).to eql collection.disabled
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.disabled.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
end
