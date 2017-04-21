class AddRelationalApiNamesToCalcStructureTypes < ActiveRecord::Migration
  def up
    add_column :calc_structure_types, :parent_api_name, :string
    add_column :calc_structure_types, :genus_api_name, :string

    CalcStructureType.update_all('genus_api_name = api_name')

    change_column :calc_structure_types, :genus_api_name, :string, null: false
  end

  def down
    remove_column :calc_structure_types, :parent_api_name, :string
    remove_column :calc_structure_types, :genus_api_name, :string
  end
end
