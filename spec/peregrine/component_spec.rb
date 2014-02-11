require 'spec_helper'

class TestComponent < Peregrine::Component
  attr_accessor :data
  
  def initialize_data(*arguments)
    (@data ||= []).push(*arguments)
  end
end

describe Peregrine::Component do
  let(:component) { Peregrine::Component }
  let(:entity)    { Peregrine::Entity.new }
  
  describe 'class' do
    it 'includes Peregrine::Features' do
      expect(component.ancestors).to include Peregrine::Features
    end
  end
  
  describe '.new' do
    it 'passes given arguments to #initialize_data' do
      tester = TestComponent.new(:expected, :data)
      expect(tester.data).to eql [:expected, :data]
    end
    
    context 'with block' do
      it 'yields the newly instanced Component' do
        instance = nil
        expect(component.new { |c| instance = c }).to be instance
      end
    end
  end
end
