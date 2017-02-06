module Formotion
  module RowType
    class RequiredStringRow < StringRow
      def valid?
        super && row_value.to_s != ''
      end
    end
  end
end
