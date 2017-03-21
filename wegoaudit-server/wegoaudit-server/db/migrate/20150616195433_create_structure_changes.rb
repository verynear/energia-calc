class CreateStructureChanges < ActiveRecord::Migration
  def change
    create_table :structure_changes do |t|
      t.integer :measure_selection_id, null: false
      t.uuid :original_structure_wegoaudit_id
      t.timestamps
    end
    add_foreign_key :structure_changes, :measure_selections
  end
end
