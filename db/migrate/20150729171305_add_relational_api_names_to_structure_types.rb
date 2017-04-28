class AddRelationalApiNamesToStructureTypes < ActiveRecord::Migration
  def up
    add_column :structure_types, :parent_api_name, :string
    add_column :structure_types, :genus_api_name, :string

    StructureType.update_all('genus_api_name = api_name')

    change_column :structure_types, :genus_api_name, :string, null: false
  end

  def down
    remove_column :structure_types, :parent_api_name, :string
    remove_column :structure_types, :genus_api_name, :string
  end
end
