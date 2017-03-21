class CreateCalcStructureTypes < ActiveRecord::Migration
  def change
    create_table :calc_structure_types do |t|
      t.string :name, null: false
      t.string :api_name, null: false
    end

    add_index :calc_structure_types, :api_name, unique: true
  end
end
