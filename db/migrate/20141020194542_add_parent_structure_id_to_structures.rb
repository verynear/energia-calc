class AddParentStructureIdToStructures < ActiveRecord::Migration
  def change
    add_column :structures, :parent_structure_id, :uuid, index: true
  end
end
