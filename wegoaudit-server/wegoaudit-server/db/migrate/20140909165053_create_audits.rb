class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits, id: :uuid do |t|
      t.string :name, null: false
      t.boolean :is_archived, default: false
      t.datetime :performed_on, null: false
      t.uuid :user_id, index: true

      t.timestamps
    end
  end
end
