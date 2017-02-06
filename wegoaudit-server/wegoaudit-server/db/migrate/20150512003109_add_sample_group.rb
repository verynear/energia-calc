class AddSampleGroup < ActiveRecord::Migration
  def change
    create_table :sample_groups, id: :uuid do |t|
      t.uuid :parent_structure_id, null: false, index: true
      t.uuid :structure_type_id, null: false
      t.string :name, null: false
      t.integer :n_structures
      t.datetime :successful_upload_on
      t.datetime :upload_attempt_on
      t.datetime :full_download_on
      t.datetime :destroy_attempt_on

      t.timestamps
    end

    add_column :structures, :sample_group_id, :uuid
  end
end
