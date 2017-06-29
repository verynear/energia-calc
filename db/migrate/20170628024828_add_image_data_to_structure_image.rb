class AddImageDataToStructureImage < ActiveRecord::Migration
  def change
  	add_column :structure_images, :image_data, :text
  end
end
