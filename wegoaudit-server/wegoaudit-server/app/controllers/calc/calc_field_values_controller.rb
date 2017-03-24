class Calc::CalcFieldValuesController < SecuredController
  before_action :set_parent

  def update
    calc_field_value = @parent.calc_field_values.find(params[:id])
    calc_field_value.value = params[:value]
    calc_field_value.save!

    json = {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @audit_report
      ).as_json
    }

    render json: json
  end

  private

  def set_parent
    if params[:measure_selection_id]
      @parent = MeasureSelection.find(params[:measure_selection_id])
      @audit_report = @parent.audit_report
    elsif params[:structure_id]
      @parent = CalcStructure.find(params[:structure_id])
      @audit_report = @parent.measure_selection.audit_report
    elsif params[:audit_report_id]
      @audit_report = @parent = AuditReport.find(params[:audit_report_id])
    end

    # unless @parent.belongs_to_user?(current_user)
    #   render nothing: true, status: 403
    #   return false
    # end

    true
  end
end
