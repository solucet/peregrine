require 'spec_helper'

describe Peregrine::Features::Taggable do
  before(:each) { Object.send(:include, subject) }
  let(:object)  { Object.new }
  let(:prepared_object) do
    object.add_tags(:test, true)
    object
  end
  
  describe '#tags' do
    it 'is lazily evaluated' do
      expect(object.instance_variable_get(:@tags)).to be nil
      expect(object.tags).to be_empty
    end
  end
  
  describe '#add_tags' do
    it 'pushes the given tags' do
      object.add_tags(:test, 'objects', true)
      expect(object.tags).to eql [:test, 'objects', true]
    end
    
    it 'ignores given tags identical to existing tags' do
      prepared_object.add_tags(:test, true, false)
      expect(prepared_object.tags).to eql [:test, true, false]
    end
    
    it 'returns an array of all object tags' do
      expect(object.add_tags(:test, true)).to eql object.tags
    end
  end
  
  describe '#remove_tags!' do
    it 'removes the given tags' do
      prepared_object.remove_tags!(true)
      expect(prepared_object.tags).to eql [:test]
    end
    
    it 'returns an array of removed tags' do
      expect(prepared_object.remove_tags!(true)).to eql [true]
    end
  end
end
