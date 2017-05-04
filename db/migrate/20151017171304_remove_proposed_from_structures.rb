class RemoveProposedFromStructures < ActiveRecord::Migration
  def up
    remove_column :fields, :proposed_only
  end

  def down
    add_column :fields, :proposed_only, :boolean, default: false
  end
end
