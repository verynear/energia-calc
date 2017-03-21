class AddCalcEmailUniqueIndex < ActiveRecord::Migration
  def change
  	add_index :calc_users, :email,                unique: true
  end
end
