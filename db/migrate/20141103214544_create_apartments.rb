class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments, id: :uuid do |t|
      t.integer :wegowise_id, index: true
      t.uuid    :building_id, index: true, null: false
      t.string  :unit_number, null: false
      t.integer :sqft,        null: false
      t.integer :n_bedrooms,  null: false
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
