class CreateStructures < ActiveRecord::Migration
  def up
    create_table :structures do |t|
      t.string :name
      t.boolean :proposed

      t.integer :structure_change_id

      t.timestamps
    end

    rename_column :structure_changes,
                  :original_structure_wegoaudit_id,
                  :structure_wegoaudit_id

    add_foreign_key :structures,
                    :structure_changes,
                    on_delete: :cascade
  end

  def down
    drop_table :structures

    rename_column :structure_changes,
                  :structure_wegoaudit_id,
                  :original_structure_wegoaudit_id
  end
end
