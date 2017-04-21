class AddNotesToMeasureSelections < ActiveRecord::Migration
  def change
    add_column :measure_selections, :notes, :text
  end
end
