class AddDefaultValueToCalcFieldValues < ActiveRecord::Migration
  def up
    change_column :calc_field_values, :value, :string, null: false, default: ''
  end

  def down
    change_column :calc_field_values, :value, :string
  end
end
