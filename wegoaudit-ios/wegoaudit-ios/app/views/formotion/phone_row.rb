module Formotion
  module RowType
    class PhoneRow < StringRow
      def valid?
        super && (row_value.to_s == '' || !!(row_value.gsub(/[^\d]/, '') =~ /\A1?\d{10}\z/))
      end
    end
  end
end
