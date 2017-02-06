class RenameWegowiseUserIdToWegowiseId < ActiveRecord::Migration
  def change
    rename_column :users, :wegowise_user_id, :wegowise_id
  end
end
