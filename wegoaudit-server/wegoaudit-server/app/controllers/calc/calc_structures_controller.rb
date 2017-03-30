class Calc::CalcStructuresController < SecuredController
  before_action :set_structure

  def update
    @calc_structure.update!(calc_structure_params)

    json = {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @calc_structure.measure_selection.audit_report
      ).as_json
    }

    render json: json
  end

  private

  def set_structure
    @calc_structure = CalcStructure.find(params[:id])

    # unless @structure.belongs_to_user?(current_user)
    #   render nothing: true, status: 403
    #   return false
    # end

    true
  end

  private

  def calc_structure_params
    params.require(:calc_structure).permit(:name, :quantity)
  end
end
