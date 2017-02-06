class MeasureValuesController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_measure_value, only: [:show, :update]

  def index
    render json: MeasureValue.all
  end

  def create
    render json: process_object(MeasureValue, measure_value_params)
  end

  def update
    render json: process_object(MeasureValue, measure_value_params)
  end

  def show
    render json: @measure_value
  end

  private

  def measure_value_params
    params.require(:measure_value).permit(:id,
                                          :audit_id,
                                          :created_at,
                                          :destroy_attempt_on,
                                          :measure_id,
                                          :notes,
                                          :successful_upload_on,
                                          :updated_at,
                                          :upload_attempt_on,
                                          :value)
  end

  def load_measure_value
    @measure_value = MeasureValue.find(params[:id]) if params[:id]
  end
end
