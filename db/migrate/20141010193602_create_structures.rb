class CreateStructures < ActiveRecord::Migration
  def change
    create_table :audit_structures, id: :uuid do |t|
      t.uuid :audit_strc_type_id, index: true
      t.string :name
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on

      t.timestamps
    end
  end
end
