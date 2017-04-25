class AddLevelToFields < ActiveRecord::Migration
  def change
    add_column :fields, :level, :string, default: 'structure'
  end
end
