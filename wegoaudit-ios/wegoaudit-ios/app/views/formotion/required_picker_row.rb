module Formotion
  module RowType
    class RequiredPickerRow < PickerRow
      def valid?
        super && row.text_field.text.to_s != ''
      end
    end
  end
end
