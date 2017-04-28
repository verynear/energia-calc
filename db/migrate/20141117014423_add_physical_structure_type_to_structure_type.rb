class AddPhysicalStructureTypeToStructureType < ActiveRecord::Migration
  def change
    add_column :audit_strc_types, :physical_structure_type, :string
  end
end
