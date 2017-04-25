class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name, null: false
      t.string :api_name, null: false
      t.string :value_type, null: false
    end

    add_index :fields, :api_name, unique: true
  end
end
