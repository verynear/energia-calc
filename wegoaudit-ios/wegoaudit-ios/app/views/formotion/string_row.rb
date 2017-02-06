module Formotion
  module RowType
    class StringRow < Base
      def validate!
        return unless row.text_field

        if valid?
          row.text_field.rightViewMode = UITextFieldViewModeNever
          row.text_field.rightView = nil
          row.text_field.textColor = UIColor.blackColor
        else
          error_image = UIImage.imageNamed('icon-warning.png')
          error_view = UIImageView.alloc.initWithFrame(CGRect.new(
            [0, 0],
            [error_image.size.width + 10, error_image.size.height]))

          error_view.image = error_image
          error_view.contentMode = UIViewContentModeCenter

          row.text_field.rightView = error_view
          row.text_field.rightViewMode = UITextFieldViewModeUnlessEditing
          row.text_field.textColor = UIColor.redColor
        end
      end
    end
  end
end
