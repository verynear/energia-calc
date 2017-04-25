class CreateAuditMeasureValues < ActiveRecord::Migration
  def change
    create_table :audit_measure_values, id: :uuid do |t|
      t.uuid :audit_measure_id, null: false, index: true
      t.uuid :audit_id, null: false, index: true
      t.boolean :value, default: false
      t.string :notes
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
