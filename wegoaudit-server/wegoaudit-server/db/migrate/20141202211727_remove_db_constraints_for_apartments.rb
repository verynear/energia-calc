class RemoveDbConstraintsForApartments < ActiveRecord::Migration
  def change
      change_column :apartments, :building_id, :uuid, null: true
      change_column :apartments, :unit_number, :string, null: true
      change_column :apartments, :sqft,        :integer, null: true
      change_column :apartments, :n_bedrooms,  :integer, null: true
  end
end
