class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :provider
      t.integer :wegowise_user_id
      t.string :token
      t.string :secret
      t.string :phone
      t.string :first_name
      t.string :last_name
      t.string :organization

      t.timestamps
    end
  end
end
