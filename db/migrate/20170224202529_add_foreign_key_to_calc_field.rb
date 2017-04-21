class AddForeignKeyToCalcField < ActiveRecord::Migration
  def change
  	add_foreign_key :calc_field_values, :calc_fields, column: :field_api_name, primary_key: :api_name, on_delete: :nullify
  end
end
