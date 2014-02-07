require 'spec_helper'

describe Peregrine::Collections::Common do
  it 'includes Collections::Named and Collections::Tagged' do
    expect(subject.ancestors).to include Peregrine::Collections::Named
    expect(subject.ancestors).to include Peregrine::Collections::Tagged
  end
end
