class AddAuditReports < ActiveRecord::Migration
  def up
    create_table :audit_reports do |t|
      t.references :user, type: :uuid
      t.integer :wegoaudit_id
      t.string :name
      t.json :data
      t.timestamps
    end

    add_foreign_key :audit_reports, :users
  end

  def down
    drop_table :audit_reports
  end
end
