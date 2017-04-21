class CreateMeasureValues < ActiveRecord::Migration
  def change
    create_table :measure_values, id: :uuid do |t|
      t.uuid :measure_id, null: false, index: true
      t.uuid :audit_id, null: false, index: true
      t.boolean :value, default: false
      t.string :notes
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
