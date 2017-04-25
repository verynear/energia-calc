class AuditFieldValuesController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_audit_field_value, only: [:show]

  def index
  end

  def create
    render json: process_object(AuditFieldValue, audit_field_value_params)
  end

  def update
    render json: process_object(AuditFieldValue, audit_field_value_params)
  end

  def show
    render json: @audit_field_value
  end

  private

  def audit_field_value_params
    params.require(:audit_field_value).permit(:id,
                                        :destroy_attempt_on,
                                        :audit_field_id,
                                        :structure_id,
                                        :string_value,
                                        :float_value,
                                        :decimal_value,
                                        :integer_value,
                                        :date_value,
                                        :boolean_value,
                                        :successful_upload_on,
                                        :upload_attempt_on,
                                        :created_at,
                                        :updated_at)
  end

  def load_audit_field_value
    @audit_field_value = AuditFieldValue.find(params[:id]) if params[:id]
  end
end
