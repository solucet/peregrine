require 'spec_helper'

describe Peregrine::Collections do
  let(:all_extensions) do
    Peregrine::Collections.constants.map do |const|
      Peregrine::Collections.const_get(const)
    end
  end
  
  describe '.extended' do
    it 'extends all Collections constants to parent' do
      parent     = Object.new.extend(Peregrine::Collections)
      extensions = parent.singleton_class.included_modules
      expect(extensions).to include *all_extensions
    end
  end
end
