class AddStructureChangeSets < ActiveRecord::Migration
  def up
    create_table :structure_change_sets do |t|
      t.integer :measure_selection_id, null: false
    end
    remove_column :structure_changes, :measure_selection_id
    add_column :structure_changes,
               :structure_change_set_id,
               :integer,
               null: false
    add_foreign_key :structure_changes, :structure_change_sets, on_delete: :cascade
    add_foreign_key :structure_change_sets, :measure_selections, on_delete: :cascade
  end

  def down
    remove_column :structure_changes, :structure_change_set_id
    drop_table :structure_change_sets
    add_column :structure_changes,
               :measure_selection_id,
               :integer,
               null: false
    add_foreign_key :structure_changes, :measure_selections
  end
end
