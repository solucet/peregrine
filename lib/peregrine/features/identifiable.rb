module Peregrine
  module Features
    # Provides the +id+ method to extract an object's +object_id+ as a hex
    # string. Intended to be included in classes requiring this functionality.
    module Identifiable
      # Returns the object's +object_id+ as a hexadecimal string.
      def id
        '0x' << (object_id << 1).to_s(16)
      end
    end
  end
end
