class CreateAuditTypes < ActiveRecord::Migration
  def change
    create_table :audit_types, id: :uuid  do |t|
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
