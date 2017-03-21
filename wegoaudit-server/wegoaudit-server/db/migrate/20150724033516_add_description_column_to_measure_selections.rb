class AddDescriptionColumnToMeasureSelections < ActiveRecord::Migration
  def change
    add_column :measure_selections, :description, :text
  end
end
