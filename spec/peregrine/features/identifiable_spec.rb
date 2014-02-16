require 'spec_helper'

describe Peregrine::Features::Identifiable do
  describe '#id' do
    it 'returns the object_id as #inspect-style hex string' do
      object = Object.new.extend(subject)
      expect(object.id).to eql '0x' << (object.object_id << 1).to_s(16)
    end
  end
end