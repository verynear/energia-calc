class FieldEnumerationsController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_field_enumeration

  def index
    render json: FieldEnumeration.all
  end

  private

  def field_enumeration_params
    params.require(:field_enumeration).permit(:id,
                                        :field_id,
                                        :string_value,
                                        :value,
                                        :display_order,
                                        :integer_value,
                                        :successful_upload_on,
                                        :upload_attempt_on,
                                        :created_at,
                                        :updated_at)
  end

  def load_field_enumeration
    @field_enumeration = FieldEnumeration.find(params[:id]) if params[:id]
  end

end
