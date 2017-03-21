class AddWegoauditPhotoIdToMeasureSelection < ActiveRecord::Migration
  def change
    add_column :measure_selections, :wegoaudit_photo_id, :string
  end
end
