class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name
      t.uuid :owner_id, index: true
      t.integer :wegowise_id, index: true

      t.timestamps
    end
  end
end
