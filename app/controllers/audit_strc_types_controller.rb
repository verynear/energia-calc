class AuditStrcTypesController < SecuredController

  def index
    render json: AuditStrcType.all
  end

  def subtypes
  	@parent_type = AuditStrcType.find(params[:id])

    render json: StructureTypeSubtypesPresenter.new(
    	@parent_type,
      subtype_params
    )
  end

  private

  def subtype_params
    if params[:selected]
    	params[:selected]
    else
    	params[:selectedTypeId]
    end
  end
end
