module Formotion
  module RowType
    class Base
      def valid?
        true # Subclasses should define their own validation
      end

      def validate!
      end
    end
  end
end
