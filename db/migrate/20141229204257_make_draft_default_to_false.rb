class MakeDraftDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :buildings, :draft, :boolean, default: true, null: true
    change_column :buildings, :object_type, :string, null: true
    change_column :buildings, :street_address, :string, null: true
    change_column :buildings, :city, :string, null: true
    change_column :buildings, :state_code, :string, null: true
    change_column :buildings, :zip_code, :string, null: true
  end
end
