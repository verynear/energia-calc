class AddCalculateOrderToMeasureSelections < ActiveRecord::Migration
  def change
    change_table :measure_selections do |t|
      t.integer :calculate_order
    end
  end
end
