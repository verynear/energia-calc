module Formotion
  module RowType
    class NumberRow < StringRow
      def valid?
        super && (row_value.to_s == '' || Float(row_value.to_s))
      rescue
        false
      end
    end
  end
end
