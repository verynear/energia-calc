class AddStructureTypeToStructureChanges < ActiveRecord::Migration
  def change
    change_table :structure_changes do |t|
      t.integer :structure_type_id
    end
  end
end
