class FieldEnumerationsController < SecuredController
  def index
    render json: FieldEnumeration.all
  end
end
