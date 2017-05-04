class CreateAuditFields < ActiveRecord::Migration
  def change
    create_table :audit_fields, id: :uuid do |t|
      t.string :name, null: false
      t.string :placeholder
      t.string :value_type, null: false
      t.integer :display_order, null: false
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on
      t.uuid :grouping_id, index: true

      t.timestamps
    end
  end
end
