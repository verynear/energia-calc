class ConvertFieldValueStringToText < ActiveRecord::Migration
  def up
    change_column :field_values, :string_value, :text
  end

  def down
    change_column :field_values, :string_value, :string
  end
end
