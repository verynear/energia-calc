class ConvertFieldValueStringToText < ActiveRecord::Migration
  def up
    change_column :audit_field_values, :string_value, :text
  end

  def down
    change_column :audit_field_values, :string_value, :string
  end
end
