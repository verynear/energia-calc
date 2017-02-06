class MetersController < SecuredController
  include RemoteObjectProcessing

  def create
    render json: process_object(Meter, meter_params)
  end

  def update
    render json: process_object(Meter, meter_params)
  end

  private

  def meter_params
    params.require(:meter).permit(:account_number,
                                  :attempted_import_at,
                                  :buildings_count,
                                  :cloned,
                                  :coverage,
                                  :created_at,
                                  :data_type,
                                  :destroy_attempt_on,
                                  :for_heating,
                                  :id,
                                  :importer_version,
                                  :n_buildings,
                                  :notes,
                                  :other_utility_company,
                                  :scope,
                                  :status,
                                  :status_changed_at,
                                  :successful_import_at,
                                  :successful_upload_on,
                                  :tenant_pays,
                                  :updated_at,
                                  :upload_attempt_on,
                                  :utility_company_name,
                                  :utility_company_wegowise_id,
                                  :wegowise_id)
  end
end
