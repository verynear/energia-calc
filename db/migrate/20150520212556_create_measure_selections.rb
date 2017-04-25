class CreateMeasureSelections < ActiveRecord::Migration
  def change
    create_table :measure_selections do |t|
      t.integer :audit_report_id, null: false
      t.integer :measure_id, null: false
      t.timestamps
    end

    add_foreign_key :measure_selections, :audit_reports
    add_foreign_key :measure_selections, :measures
  end
end
