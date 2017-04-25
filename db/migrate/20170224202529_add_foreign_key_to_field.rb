class AddForeignKeyToField < ActiveRecord::Migration
  def change
  	add_foreign_key :field, :field_values, on_delete: :nullify
  end
end
