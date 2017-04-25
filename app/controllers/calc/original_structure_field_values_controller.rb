class Calc::OriginalStructureFieldValuesController < SecuredController
  before_action :set_parent

  def update
    field_value = @audit_report.original_structure_field_values
      .find(params[:id])
    field_value.value = params[:value]
    field_value.save!

    calculator = AuditReportCalculator.new(audit_report: @audit_report)
    json = {
      new_value: field_value.value,
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @audit_report,
        audit_report_calculator: calculator
      ).as_json
    }

    render json: json
  end

  private

  def set_parent
    @audit_report = AuditReport.find(params[:audit_report_id])

    # unless @audit_report.belongs_to_user?(current_user)
    #   render nothing: true, status: 403
    #   return false
    # end

    true
  end
end
