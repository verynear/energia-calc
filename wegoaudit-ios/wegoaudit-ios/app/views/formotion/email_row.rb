module Formotion
  module RowType
    class EmailRow < StringRow
      def valid?
        super && (row_value.to_s == '' || !!(row_value =~ /.+@.+\..+/i))
      end
    end
  end
end
