class SetWegowiseIdNotNull < ActiveRecord::Migration
  def change
  	change_column_null :calc_users, :wegowise_id, true
  end
end
