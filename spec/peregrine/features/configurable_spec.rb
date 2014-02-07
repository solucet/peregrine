require 'spec_helper'

describe Peregrine::Features::Configurable do
  before(:each) { Object.send(:include, subject) }
  let(:object)  { Object.new }
  
  describe '#configure' do
    it 'yields the object called upon' do
      instance = nil
      object.configure { |o| instance = o }
      expect(object).to be instance
    end
    
    it 'returns the object called upon' do
      expect(object.configure).to be object
    end
  end
end
