class AddClonedToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :cloned, :boolean, default: true
  end
end
