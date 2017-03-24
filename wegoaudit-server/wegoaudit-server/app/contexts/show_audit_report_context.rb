class ShowAuditReportContext < BaseContext
  attr_accessor :audit_report,
                :user

  def audit_report_as_json
    { measureModalUrl: measure_modal_url,
      audit_report: audit_report_json }
  end

  private

  def audit_report_json
    AuditReportSerializer.new(audit_report: audit_report).as_json
  end

  def measure_modal_url
    url_helpers.new_calc_audit_report_measure_selection_path(audit_report)
  end
end
