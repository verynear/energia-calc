class AddCascadingDeleteFromMeasures < ActiveRecord::Migration
  def up
    remove_foreign_key :measure_selections, :calc_measures
    add_foreign_key :measure_selections, :calc_measures, on_delete: :cascade
  end

  def down
    remove_foreign_key :measure_selections, :calc_measures
    add_foreign_key :measure_selections, :calc_measures
  end
end
