class ChangeAuditReportWegoauditId < ActiveRecord::Migration
  def up
    remove_column :audit_reports, :wegoaudit_id
    add_column :audit_reports, :wegoaudit_id, :uuid, null: false
  end

  def down
    remove_column :audit_reports, :wegoaudit_id
    add_column :audit_reports, :wegoaudit_id, :integer
  end
end
