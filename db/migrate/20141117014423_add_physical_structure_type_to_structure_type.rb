class AddPhysicalStructureTypeToStructureType < ActiveRecord::Migration
  def change
    add_column :structure_types, :physical_structure_type, :string
  end
end
