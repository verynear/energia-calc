class AddProposedOnlyFlagToCalcFields < ActiveRecord::Migration
  def change
    add_column :calc_fields, :proposed_only, :boolean, default: false
  end
end
