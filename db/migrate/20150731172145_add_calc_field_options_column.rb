class AddCalcFieldOptionsColumn < ActiveRecord::Migration
  def change
    add_column :calc_fields, :options, :string, array: true, default: []
  end
end
