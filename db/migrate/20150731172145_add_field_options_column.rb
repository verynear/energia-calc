class AddFieldOptionsColumn < ActiveRecord::Migration
  def change
    add_column :fields, :options, :string, array: true, default: []
  end
end
