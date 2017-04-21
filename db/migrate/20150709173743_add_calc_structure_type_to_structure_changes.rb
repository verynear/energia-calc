class AddCalcStructureTypeToStructureChanges < ActiveRecord::Migration
  def change
    change_table :structure_changes do |t|
      t.integer :calc_structure_type_id
    end
  end
end
