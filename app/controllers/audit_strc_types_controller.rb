class AuditStrcTypesController < SecuredController
  # before_filter :authenticate_user!

  def index
    render json: AuditStrcType.all
  end

  def subtypes
    render json: StructureTypeSubtypesPresenter.new(
      AuditStrcType.find(params[:id]),
      params[:selected]
    )
  end
end
