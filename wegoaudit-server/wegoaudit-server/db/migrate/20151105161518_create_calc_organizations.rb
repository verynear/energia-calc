class CreateCalcOrganizations < ActiveRecord::Migration
  def change
    create_table :calc_organizations do |t|
      t.string :name
      t.integer :wegowise_id, index: true

      t.timestamps
    end
  end
end
