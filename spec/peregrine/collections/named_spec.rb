require 'spec_helper'

describe Peregrine::Collections::Named do
  let(:collection) do
    [ Peregrine::Entity.new { |e| e.name = 'Tester' },
      Peregrine::Entity.new { |e| e.name = 'Second tester' } ].extend(subject)
  end
  
  describe '#named' do
    context 'given a regular expression' do
      it 'returns an array of items with matching name' do
        expect(collection.named(/tester/i)).to eql collection
        expect(collection.named(/Second/)).to eql [collection.last]
      end
    end
    
    context 'given a string' do
      it 'returns an array of items with exact given name' do
        expect(collection.named('Tester')).to eql [collection.first]
        expect(collection.named('Second')).to be_empty
      end
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.named(/test/i) do |item|
          expectation << item
        end
        expect(expectation).to eq collection.named(/test/i)
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.named(//).singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
end
