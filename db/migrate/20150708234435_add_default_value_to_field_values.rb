class AddDefaultValueToFieldValues < ActiveRecord::Migration
  def up
    change_column :field_values, :value, :string, null: false, default: ''
  end

  def down
    change_column :field_values, :value, :string
  end
end
