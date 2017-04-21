class CreateStructureImages < ActiveRecord::Migration
  def change
    create_table :structure_images, id: :uuid do |t|
      t.attachment :asset
      t.string :file_name, null: false
      t.string :s3_path
      t.uuid :structure_id, null: false, index: true
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
