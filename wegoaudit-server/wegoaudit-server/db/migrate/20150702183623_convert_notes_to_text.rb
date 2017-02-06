class ConvertNotesToText < ActiveRecord::Migration
  def up
    change_column :measure_values, :notes, :text
  end

  def down
    change_column :measure_values, :notes, :string
  end
end
