require 'spec_helper'

describe Peregrine::Features::Nameable do
  before(:each) { Object.send(:include, subject) }
  let(:object)  { Object.new }
  
  describe '#name' do
    it 'is lazily evaluated' do
      expect(object.instance_variable_get(:@name)).to be nil
      expect(object.name).not_to be nil
    end
    
    it 'defaults to object class converted to String' do
      expect(object.name).to eql 'Object'
    end
  end
  
  describe '#name=' do
    it 'sets object name to value converted to String' do
      object.name = :test
      expect(object.name).to eql 'test'
    end
  end
end
