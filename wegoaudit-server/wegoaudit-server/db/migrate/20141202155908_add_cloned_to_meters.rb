class AddClonedToMeters < ActiveRecord::Migration
  def change
    add_column :meters, :cloned, :boolean, default: true
  end
end
