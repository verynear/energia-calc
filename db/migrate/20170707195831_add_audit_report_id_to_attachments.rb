class AddAuditReportIdToAttachments < ActiveRecord::Migration
  def change
  	add_column :attachments, :audit_report_id, :integer
  end
end
