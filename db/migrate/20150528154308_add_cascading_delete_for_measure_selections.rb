class AddCascadingDeleteForMeasureSelections < ActiveRecord::Migration
  def up
    remove_foreign_key :measure_selections, :audit_reports
    add_foreign_key :measure_selections, :audit_reports, on_delete: :cascade
  end

  def down
    remove_foreign_key :measure_selections, :audit_reports
    add_foreign_key :measure_selections, :audit_reports
  end
end
