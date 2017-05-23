class ApartmentsController < SecuredController
  include RemoteObjectProcessing

  def create
    render json: process_object(Apartment, apartment_params)
  end

  def update
    render json: process_object(Apartment, apartment_params)
  end

  private

  def process_apartment
    service = HandlerService.new(object_class: Apartment,
                                 params: building_params)
    service.execute!
    @apartment = service.object

    successful_upload if @apartment.valid? && !@apartment.destroyed?

    render json: @apartment
  end

  def successful_upload
    @apartment.update_attribute(:successful_upload_on, @apartment.upload_attempt_on)
  end

  def apartment_params
    params.permit(:building_id,
                  :cloned,
                  :created_at,
                  :destroy_attempt_on,
                  :id,
                  :n_bedrooms,
                  :sqft,
                  :successful_upload_on,
                  :unit_number,
                  :updated_at,
                  :upload_attempt_on,
                  :wegowise_id)
  end
end
