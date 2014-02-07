require 'spec_helper'

describe Peregrine::Features do
  let(:all_features) do
    Peregrine::Features.constants.map do |const|
      Peregrine::Features.const_get(const)
    end
  end
  
  describe '.included' do
    it 'includes all Features constants in parent' do
      parent = Object.send(:include, Peregrine::Features)
      expect(Object.ancestors).to include *all_features
    end
  end
end
