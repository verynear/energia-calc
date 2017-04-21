class AddAssetProcessingToStructureImages < ActiveRecord::Migration
  def up
    add_column :structure_images, :asset_processing, :boolean
  end

  def down
    remove_column :structure_images, :asset_processing
  end
end
