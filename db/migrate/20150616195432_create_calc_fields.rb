class CreateCalcFields < ActiveRecord::Migration
  def change
    create_table :calc_fields do |t|
      t.string :name, null: false
      t.string :api_name, null: false
      t.string :value_type, null: false
    end

    add_index :calc_fields, :api_name, unique: true
  end
end
