module Formotion
  module RowType
    class MeasureRow < SubformRow
      include BW::KVO

      LABEL_TAG=1001

      attr_accessor :field, :switchView

      def switch_changed
        if switchView.isOn
          self.row.value = true
          self.tableView
              .delegate
              .tableView(self.tableView, didSelectRowAtIndexPath: self.row.index_path)
        else
          self.row.value = false
        end
      end

      def build_cell(cell)
        cell.selectionStyle = self.row.selection_style || UITableViewCellSelectionStyleNone
        @switchView = UISwitch.alloc.initWithFrame(CGRectZero)
        @switchView.enabled = row.editable?
        switchView.accessibilityLabel = (row.title || "") + " Switch"
        cell.accessoryView = cell.editingAccessoryView = switchView

        switchView.setOn(row.value || false, animated:false)

        switchView.addTarget(self,
                             action: 'switch_changed',
                             forControlEvents: UIControlEventValueChanged);

                cell.contentView.addSubview(self.display_key_label)

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            formotion_label = self.viewWithTag(LABEL_TAG)
            formotion_label.sizeToFit

            field_frame = formotion_label.frame
            # HARDCODED CONSTANT
            field_frame.origin.x = self.contentView.frame.size.width - field_frame.size.width - 10
            field_frame.origin.y = ((self.contentView.frame.size.height - field_frame.size.height) / 2.0).round
            formotion_label.frame = field_frame
          end
        end

        display_key_label.highlightedTextColor = cell.textLabel.highlightedTextColor
        nil
      end

      def on_select(tableView, tableViewDelegate)
        if self.switchView.isOn

          subform = row.subform.to_form
          subform.sections.each do |subsection|
            subsection.rows.each do |subrow|
              subrow.editable = row.editable
            end
          end
          row.form.controller.push_subform(subform)
        end
      end
    end
  end
end
