class AuditFieldsController < SecuredController
  def index
    render json: AuditField.all
  end
end
