class AuditReportSerializer < Generic::Strict
  attr_accessor :audit_report,
                :audit_report_calculator

  def initialize(*)
    super
    self.audit_report_calculator ||= AuditReportCalculator.new(
      audit_report: audit_report)
  end

  def as_json
    {
      id: audit_report.id,
      measure_selections: measure_selections_json,
      audit_report_summary: audit_report_summary_json
    }
  end

  private

  def audit_report_summary_json
    AuditReportSummarySerializer.new(
      audit_report: audit_report,
      audit_report_calculator: audit_report_calculator).as_json
  end

  def measure_selections_json
    audit_report.measure_selections
      .includes(
        :measure,
        :structure_changes,
        :field_values).map do |selection|
      measure_summary =
        audit_report_calculator.summary_for_measure_selection(selection)
      MeasureSelectionSerializer.new(
        measure_selection: selection,
        measure_summary: measure_summary).as_json
    end
  end
end
