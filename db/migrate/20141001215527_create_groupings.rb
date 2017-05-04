class CreateGroupings < ActiveRecord::Migration
  def change
    create_table :groupings, id: :uuid do |t|
      t.uuid :audit_strc_type_id, index: true
      t.string :name, null: false
      t.integer :display_order, null: false
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on

      t.timestamps
    end
  end
end
