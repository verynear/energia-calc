class AuditMeasuresController < SecuredController
  def index
    @audit_measures = AuditMeasure.all
    respond_to do |format|
      format.json do
        render json: @audit_measures
      end
    end
  end
end
