class SetDefaultProvider < ActiveRecord::Migration
  def change
  	change_column :calc_users, :provider, :string, :default => 'wegowise'
  end
end
