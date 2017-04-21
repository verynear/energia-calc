class NullOrganization
  def audit_reports
    AuditReport.none
  end

  def report_templates
    ReportTemplate.none
  end
end
