class ConvertNotesToText < ActiveRecord::Migration
  def up
    change_column :audit_measure_values, :notes, :text
  end

  def down
    change_column :audit_measure_values, :notes, :string
  end
end
