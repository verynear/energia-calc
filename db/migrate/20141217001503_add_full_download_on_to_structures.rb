class AddFullDownloadOnToStructures < ActiveRecord::Migration
  def change
    add_column :audit_structures, :full_download_on, :datetime
  end
end
