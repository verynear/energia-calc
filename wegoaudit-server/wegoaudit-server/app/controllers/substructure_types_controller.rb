class SubstructureTypesController < SecuredController
  def index
    render json: SubstructureType.all
  end
end
