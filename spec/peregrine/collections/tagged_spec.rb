require 'spec_helper'

describe Peregrine::Collections::Tagged do
  let(:collection) { [:test, :symbol, :untagged].extend(subject) }
  before(:each) do
    Symbol.send(:include, Peregrine::Features::Taggable)
    :test.add_tags('test', 'symbol')
    :symbol.add_tags('symbol')
  end
  
  describe '#tagged' do
    it 'returns an array of items with all of the given tags' do
      expect(collection.tagged('test', 'symbol')).to eql [collection.first]
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.tagged('test', 'symbol') do |item|
          expectation << item
        end
        expect(expectation).to eql collection.tagged('test', 'symbol')
      end
    end
    
    it 'returns an array extended with Peregrine::Collections' do
      extensions = collection.tagged(:test).singleton_class.included_modules
      expect(extensions).to include Peregrine::Collections
    end
  end
  
  describe '#any_tagged' do
    it 'returns an array of items with any of the given tags' do
      expect(collection.any_tagged('test', 'symbol')).to eql collection[0..1]
    end
    
    context 'when given a block' do
      it 'yields each matching item' do
        expectation = []
        collection.any_tagged('test', 'symbol') do |item|
          expectation << item
        end
        expect(expectation).to eql collection.any_tagged('test', 'symbol')
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
