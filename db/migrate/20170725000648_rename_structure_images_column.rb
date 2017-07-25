class RenameStructureImagesColumn < ActiveRecord::Migration
  def change
  	rename_column :structure_images, :s3_path, :photo_path
  end
end
