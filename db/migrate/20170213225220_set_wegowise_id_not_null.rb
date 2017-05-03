class SetWegowiseIdNotNull < ActiveRecord::Migration
  def change
  	change_column_null :users, :wegowise_id, true
  end
end
