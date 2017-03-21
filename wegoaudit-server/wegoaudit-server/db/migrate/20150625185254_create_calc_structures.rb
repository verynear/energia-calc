class CreateCalcStructures < ActiveRecord::Migration
  def up
    create_table :calc_structures do |t|
      t.string :name
      t.boolean :proposed

      t.integer :structure_change_id

      t.timestamps
    end

    rename_column :structure_changes,
                  :original_structure_wegoaudit_id,
                  :structure_wegoaudit_id

    add_foreign_key :calc_structures,
                    :structure_changes,
                    on_delete: :cascade
  end

  def down
    drop_table :calc_structures

    rename_column :structure_changes,
                  :structure_wegoaudit_id,
                  :original_structure_wegoaudit_id
  end
end
