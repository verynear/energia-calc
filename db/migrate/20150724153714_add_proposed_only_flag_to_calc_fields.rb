class AddProposedOnlyFlagToFields < ActiveRecord::Migration
  def change
    add_column :fields, :proposed_only, :boolean, default: false
  end
end
