class AuditStrcTypesController < SecuredController

  def index
    render json: AuditStrcType.all
  end

  def subtypes
  	@parent_type = AuditStrcType.find(params[:id])
  	
    render json: StructureTypeSubtypesPresenter.new(
    	@parent_type,
      params[:selected]
    )
  end
end
