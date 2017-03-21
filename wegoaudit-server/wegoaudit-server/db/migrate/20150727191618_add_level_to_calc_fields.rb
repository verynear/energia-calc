class AddLevelToCalcFields < ActiveRecord::Migration
  def change
    add_column :calc_fields, :level, :string, default: 'structure'
  end
end
