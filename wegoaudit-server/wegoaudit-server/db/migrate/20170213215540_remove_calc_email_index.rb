class RemoveCalcEmailIndex < ActiveRecord::Migration
  def change
  	remove_index :calc_users, :email
  end
end
