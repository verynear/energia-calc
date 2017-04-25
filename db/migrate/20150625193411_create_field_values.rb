class CreateFieldValues < ActiveRecord::Migration
  def change
    create_table :field_values do |t|
      t.string :value
      t.string :field_api_name, null: false
      t.integer :calc_structure_id, null: false

      t.timestamps
    end

    add_foreign_key :field_values, :calc_structures, on_delete: :cascade

    add_index :field_values,
              [:field_api_name, :calc_structure_id],
              unique: true
  end
end
