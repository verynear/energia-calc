class AuditMeasureValuesController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_audit_measure_value, only: [:show, :update]

  def index
    render json: AuditMeasureValue.all
  end

  def create
    render json: process_object(AuditMeasureValue, audit_measure_value_params)
  end

  def update
    render json: process_object(AuditMeasureValue, audit_measure_value_params)
  end

  def show
    render json: @audit_measure_value
  end

  private

  def audit_measure_value_params
    params.require(:audit_measure_value).permit(:id,
                                          :audit_id,
                                          :created_at,
                                          :destroy_attempt_on,
                                          :audit_measure_id,
                                          :notes,
                                          :successful_upload_on,
                                          :updated_at,
                                          :upload_attempt_on,
                                          :value)
  end

  def load_audit_measure_value
    @audit_measure_value = AuditMeasureValue.find(params[:id]) if params[:id]
  end
end
