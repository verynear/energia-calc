class Calc::StructuresController < SecuredController
  before_action :set_structure

  def update
    @structure.update!(structure_params)

    json = {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: @structure.measure_selection.audit_report
      ).as_json
    }

    render json: json
  end

  private

  def set_structure
    @structure = Structure.find(params[:id])

    # unless @structure.belongs_to_user?(current_user)
    #   render nothing: true, status: 403
    #   return false
    # end

    true
  end

  private

  def structure_params
    params.require(:structure).permit(:name, :quantity)
  end
end
