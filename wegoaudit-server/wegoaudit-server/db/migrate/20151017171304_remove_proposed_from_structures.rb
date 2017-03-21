class RemoveProposedFromStructures < ActiveRecord::Migration
  def up
    remove_column :calc_fields, :proposed_only
  end

  def down
    add_column :calc_fields, :proposed_only, :boolean, default: false
  end
end
