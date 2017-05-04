class AddPhysicalStructureToStructure < ActiveRecord::Migration
  def change
    add_column :audit_structures, :physical_structure_id, :uuid
    add_column :audit_structures, :physical_structure_type, :string
    add_index :audit_structures, [:physical_structure_type, :physical_structure_id],
                           name: 'structure_physical_structure'
  end
end
