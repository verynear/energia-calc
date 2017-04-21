class AddDefaultUserorgId < ActiveRecord::Migration
  def change
  	change_column :calc_users, :wegowise_id, :integer, default: 1234
  	change_column :calc_users, :calc_organization_id, :integer, default: 2
  end
end
