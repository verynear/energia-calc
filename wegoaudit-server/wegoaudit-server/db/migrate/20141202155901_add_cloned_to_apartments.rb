class AddClonedToApartments < ActiveRecord::Migration
  def change
    add_column :apartments, :cloned, :boolean, default: true
  end
end
