class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships, id: :uuid do |t|
      t.uuid :organization_id, index: true
      t.uuid :user_id, index: true
      t.string :role
      t.string :access
      t.integer :wegowise_id, index: true

      t.timestamps
    end
  end
end
