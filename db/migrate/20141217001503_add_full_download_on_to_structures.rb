class AddFullDownloadOnToStructures < ActiveRecord::Migration
  def change
    add_column :structures, :full_download_on, :datetime
  end
end
