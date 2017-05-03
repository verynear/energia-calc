class CreateFieldEnumerations < ActiveRecord::Migration
  def change
    create_table :field_enumerations, id: :uuid do |t|
      t.uuid :audit_field_id, index: true
      t.string :value, null: false
      t.integer :display_order, null: false
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on

      t.timestamps
    end
  end
end
