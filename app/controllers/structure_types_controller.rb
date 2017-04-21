class StructureTypesController < SecuredController
  before_filter :authenticate_user!

  def index
    render json: StructureType.all
  end

  def subtypes
    render json: StructureTypeSubtypesPresenter.new(
      StructureType.find(params[:id]),
      params[:selected]
    )
  end
end
