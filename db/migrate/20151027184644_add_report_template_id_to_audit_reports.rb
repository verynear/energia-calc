class AddReportTemplateIdToAuditReports < ActiveRecord::Migration
  def change
    add_column :audit_reports, :report_template_id, :integer
  end
end
