require 'peregrine/collections/named'
require 'peregrine/collections/tagged'

module Peregrine
  module Collections
    # Includes instance method definitions available in the Collections::Named
    # and Collections::Tagged modules.
    module Common
      include Named, Tagged
    end
  end
end
