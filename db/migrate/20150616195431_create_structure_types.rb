class CreateStructureTypes < ActiveRecord::Migration
  def change
    create_table :structure_types do |t|
      t.string :name, null: false
      t.string :api_name, null: false
    end

    add_index :structure_types, :api_name, unique: true
  end
end
