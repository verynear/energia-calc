class AddForeignKeyToCalcField < ActiveRecord::Migration
  def change
  	add_foreign_key :calc_field, :calc_field_values, on_delete: :nullify
  end
end
