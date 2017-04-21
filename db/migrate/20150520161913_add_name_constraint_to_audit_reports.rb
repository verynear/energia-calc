class AddNameConstraintToAuditReports < ActiveRecord::Migration
  def up
    change_column :audit_reports, :name, :string, null: false
  end

  def down
    change_column :audit_reports, :name, :string, null: false
  end
end
