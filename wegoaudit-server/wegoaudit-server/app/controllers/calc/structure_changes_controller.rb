class Calc::StructureChangesController < SecuredController
  before_action :set_measure_selection

  def create
    structure_changes = structure_changes_params.map do |api_name, options|
      StructureChangeCreator.new(
        calc_measure: @measure_selection.calc_measure,
        calc_structure_type: CalcStructureType.find_by!(api_name: api_name),
        structure_wegoaudit_id: options.fetch(:structure_wegoaudit_id),
        measure_selection: @measure_selection
      ).create
    end

    calculator = AuditReportCalculator.new(audit_report: @measure_selection.audit_report)
    measure_summary = calculator.summary_for_measure_selection(@measure_selection)

    measure_selection_json =
      MeasureSelectionSerializer.new(
        measure_selection: @measure_selection,
        measure_summary: measure_summary).as_json

    structure_changes_json = structure_changes.map do |structure_change|
      StructureChangeSerializer.new(
        structure_change: structure_change,
        measure_selection: @measure_selection,
        measure_summary: measure_summary
      ).as_json
    end

    render json: {
      structure_changes: structure_changes_json,
      measure_selection: measure_selection_json,
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @measure_selection.audit_report
      ).as_json
    }
  end

  def destroy
    structure_change = @measure_selection.structure_changes.find(params[:id])
    structure_change.destroy

    render json: {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @measure_selection.audit_report
      ).as_json
    }
  end

  def new
    @context = NewStructureChangeContext.new(
      audit_report: @measure_selection.audit_report,
      measure_selection: @measure_selection)
    render layout: false
  end

  private

  def set_measure_selection
    @measure_selection = MeasureSelection.find(params[:measure_selection_id])
  end

  def structure_changes_params
    params.require(:structure_changes).permit!
  end
end
