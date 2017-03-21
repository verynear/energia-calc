class AddHourlyTemperaturesTable < ActiveRecord::Migration
  def change
    create_table :hourly_temperatures do |t|
      t.string :location
      t.string :state_code
      t.date :date
      t.integer :hour, limit: 1
      t.float :temperature
    end

    add_index :hourly_temperatures, [:location, :date, :hour], unique: true
  end
end
