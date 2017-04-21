class FieldsController < SecuredController
  def index
    render json: Field.all
  end
end
