class CreateOrganizationBuildings < ActiveRecord::Migration
  def change
    create_table :organization_buildings, id: :uuid do |t|
      t.uuid :organization_id, index: true
      t.uuid :building_id, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
