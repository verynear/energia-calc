class RemoveStructureChangeSets < ActiveRecord::Migration
  class StructureChange < ActiveRecord::Base
    belongs_to :structure_change_set
    belongs_to :measure_selection
  end

  class StructureChangeSet < ActiveRecord::Base
    belongs_to :measure_selection
    has_many :structure_changes
  end

  def up
    change_table :structure_changes do |t|
      t.references :measure_selection
    end
    add_foreign_key :structure_changes, :measure_selections, on_delete: :cascade
    StructureChange.all.each do |structure_change|
      structure_change.update!(
        measure_selection: structure_change.structure_change_set.measure_selection)
    end
    change_column :structure_changes, :measure_selection_id, :integer, null: false

    remove_foreign_key :structure_change_sets, :measure_selections
    remove_foreign_key :structure_changes, :structure_change_sets
    remove_column :structure_changes, :structure_change_set_id
    drop_table :structure_change_sets
  end

  def down
    create_table "structure_change_sets", force: :cascade do |t|
      t.integer "measure_selection_id", null: false
    end

    change_table :structure_changes do |t|
      t.references :structure_change_set
    end

    StructureChange.all.each do |structure_change|
      structure_change_set = StructureChangeSet.create!(
        measure_selection: structure_change.measure_selection)
      structure_change_set.structure_changes << structure_change
      structure_change_set.save!
    end

    change_column :structure_changes, :structure_change_set_id, :integer, null: false

    remove_foreign_key :structure_changes, :measure_selections
    remove_column :structure_changes, :measure_selection_id

    add_foreign_key :structure_changes, :structure_change_sets, on_delete: :cascade
    add_foreign_key :structure_change_sets, :measure_selections, on_delete: :cascade
  end
end
