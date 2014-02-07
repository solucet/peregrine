require 'spec_helper'

describe Peregrine::Collections::Tagged do
  let(:entity) { Peregrine::Entity }
  let(:collection) do
    array = [ entity.new, entity.new, :untagged ]
    array[0].add_tags('test', 'entity')
    array[1].add_tags('entity')
    array.extend(subject)
  end
  
  describe '#tagged' do
    it 'returns an array of items with all of the given tags' do
      expect(collection.tagged('test', 'entity')).to eql [collection.first]
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.tagged('test', 'entity') do |item|
          expectation << item
        end
        expect(expectation).to eql collection.tagged('test', 'entity')
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.tagged(:test).singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
  
  describe '#any_tagged' do
    it 'returns an array of items with any of the given tags' do
      expect(collection.any_tagged('test', 'entity')).to eql collection[0..1]
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.any_tagged('test', 'entity') do |item|
          expectation << item
        end
        expect(expectation).to eql collection.any_tagged('test', 'entity')
      end
    end  
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.any_tagged(:test).singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
  
  describe '#untagged' do
    it 'returns an array of items without tags' do
      expect(collection.untagged).to eql [:untagged]
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.untagged { |item| expectation << item }
        expect(expectation).to eql collection.untagged
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.untagged.singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
end
