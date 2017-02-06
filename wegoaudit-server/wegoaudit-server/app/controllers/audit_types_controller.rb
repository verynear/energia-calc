class AuditTypesController < SecuredController
  def index
    @audit_types = AuditType.all
    respond_to do |format|
      format.json do
        render json: @audit_types
      end
    end
  end
end
