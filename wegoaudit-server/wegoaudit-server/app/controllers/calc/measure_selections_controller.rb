class Calc::MeasureSelectionsController < SecuredController
  before_action :set_audit_report

  def create
    measure = CalcMeasure.find(params[:measure_selection][:measure_id])

    selection = MeasureSelectionCreator.new(
      measure: measure,
      audit_report: @audit_report).create

    calculator = AuditReportCalculator.new(audit_report: @audit_report)
    measure_summary = calculator.summary_for_measure_selection(selection)

    measure_selection_json =
      MeasureSelectionSerializer.new(
        measure_selection: selection,
        measure_summary: measure_summary).as_json

    render json: {
      measure_selection: measure_selection_json,
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @audit_report,
        audit_report_calculator: calculator
      ).as_json
    }
  end

  def destroy
    selection = @audit_report.measure_selections.find(params[:id])
    selection.destroy

    render json: {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @audit_report
      ).as_json
    }
  end

  def new
    available_measure_names = Kilomeasure.registry.names
    @calc_measures = CalcMeasure.where(api_name: available_measure_names).order(:name)
    render layout: false
  end

  def update
    selection = @audit_report.measure_selections.find(params[:id])
    selection.update!(measure_selection_params)

    calculator = AuditReportCalculator.new(audit_report: @audit_report)
    measure_summary = calculator.summary_for_measure_selection(selection)

    measure_selection_json =
      MeasureSelectionSerializer.new(
        measure_selection: selection,
        measure_summary: measure_summary).as_json

    render json: {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report_calculator: calculator,
        audit_report: @audit_report
      ).as_json,
      measure_selection: measure_selection_json
    }
  end

  private

  def measure_selection_params
    params.require(:measure_selection)
      .permit(:calculate_order_position,
              :description,
              :recommendation,
              :enabled,
              :wegoaudit_photo_id)
  end

  def set_audit_report
    @audit_report = AuditReport.find(params[:audit_report_id])
  end
end
