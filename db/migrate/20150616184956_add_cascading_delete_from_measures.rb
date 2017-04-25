class AddCascadingDeleteFromMeasures < ActiveRecord::Migration
  def up
    remove_foreign_key :measure_selections, :measures
    add_foreign_key :measure_selections, :measures, on_delete: :cascade
  end

  def down
    remove_foreign_key :measure_selections, :measures
    add_foreign_key :measure_selections, :measures
  end
end
