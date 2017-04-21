class AddPrimaryToStructureType < ActiveRecord::Migration
  def change
    add_column :structure_types, :primary, :boolean, default: false
  end
end
