class AddDefaultsToUser < ActiveRecord::Migration
  def change
  	change_column :users, :organization, :string, default: "Elevate Energy"
  	change_column :users, :wegowise_id, :integer, default: 1234
  	change_column :users, :provider, :string, default: "wegowise"
  end
end
