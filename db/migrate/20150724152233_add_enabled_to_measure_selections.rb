class AddEnabledToMeasureSelections < ActiveRecord::Migration
  def change
    change_table :measure_selections do |t|
      t.boolean :enabled, default: true
    end
  end
end
