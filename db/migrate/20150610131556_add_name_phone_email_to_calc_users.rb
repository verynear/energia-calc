class AddNamePhoneEmailToCalcUsers < ActiveRecord::Migration
  def change
    change_table :calc_users do |t|
      t.string :name
      t.string :phone
      t.string :email
    end
  end
end
