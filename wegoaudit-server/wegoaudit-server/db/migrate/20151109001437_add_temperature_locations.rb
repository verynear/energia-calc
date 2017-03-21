class AddTemperatureLocations < ActiveRecord::Migration
  def change
    create_table :temperature_locations do |t|
      t.string :state_code, null: false
      t.string :location, null: false
    end

    add_index :temperature_locations, [:location, :state_code], unique: true
  end
end
