class CreateApartmentMonthlyData < ActiveRecord::Migration
  def change
    create_table :apartment_monthly_data do |t|
      t.integer :wegowise_id, null: false
      t.string :data_type, null: false
      t.json :data

      t.timestamps
    end
  end
end
