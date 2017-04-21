class CreateCalcUsers < ActiveRecord::Migration
  def change
    create_table :calc_users do |t|
      t.integer :wegowise_id, null: false
      t.string :username
      t.string :provider, null: false
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
