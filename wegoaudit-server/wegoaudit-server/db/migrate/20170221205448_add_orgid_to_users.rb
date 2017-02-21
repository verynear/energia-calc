class AddOrgidToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :organization_id, :integer, default: 2
  end
end
