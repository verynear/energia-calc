class BuildingsController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_building, except: [:create, :index, :update]

  def index
    @organizations = Organization.all

    respond_to do |format|
      format.html do
        render :index
      end
      format.json do
        @buildings = @organizations.map(&:buildings).flatten.map do |building|
          BuildingStructurePresenter.new(building).as_json
        end
        render json: @buildings
      end
    end
  end

  def create
    render json: process_object(Building, building_params)
  end

  def update
    render json: process_object(Building, building_params)
  end

  def show
  end

  def download_apartments
    ApartmentRetrievalWorker.perform_async(@building.wegowise_id,
                                           current_user.id)
    flash[:notice] = 'Apartment updates queued for background retrieval'
    redirect_to building_path(@building)
  end

  def download_full_building
    BuildingApartmentsRetrievalWorker.perform_async(@building.wegowise_id,
                                                   current_user.id)
    BuildingMeterRetrievalWorker.perform_async(@building.wegowise_id,
                                               current_user.id)
    flash[:notice] = "Apartment and meter updates queued for background
                      retrieval for #{@building.nickname}".squish
    redirect_to buildings_path
  end

  def export_full
    @structure = FullStructurePresenter.new(@building.structure)
    render json: [@structure.as_json]
  end

  private

  def load_building
    @building = Building.find_by(id: params[:id])
  end

  def building_id
    params[:id] || params[:building][:id]
  end

  def building_params
    to_permit = building_params_to_permit
    attrs = params.require(:building).permit(*to_permit)
    attrs
  end

  def building_params_to_permit
    [:apartment_sqft,
     :apartments_count,
     :areas_count,
     :basement_conditioned,
     :basement_sqft,
     :building_type,
     :city,
     :climate_zone,
     :cloned,
     :conditioned_sqft,
     :construction,
     :cooling_system,
     :country,
     :county,
     :created_at,
     :destroy_attempt_on,
     :development_id,
     :draft,
     :dryer_fuel,
     :electric_area_meters_count,
     :electric_general_meters_count,
     :epa_certified,
     :gas_area_meters_count,
     :gas_general_meters_count,
     :green_certified,
     :has_basement,
     :has_laundry,
     :has_pool,
     :heating_fuel,
     :heating_system,
     :hot_water_fuel,
     :hot_water_system,
     :id,
     :lat,
     :leed_certified,
     :leed_level,
     :lng,
     :low_income,
     :n_apartments,
     :n_bedrooms,
     :n_electric_area_meters,
     :n_electric_general_meters,
     :n_elevators,
     :n_gas_area_meters,
     :n_gas_general_meters,
     :n_oil_area_meters,
     :n_oil_general_meters,
     :n_propane_area_meters,
     :n_propane_general_meters,
     :n_solar_area_meters,
     :n_solar_general_meters,
     :n_steam_area_meters,
     :n_steam_general_meters,
     :n_stories,
     :n_water_area_meters,
     :n_water_general_meters,
     :nahb_certified,
     :nickname,
     :notes,
     :object_type,
     :oil_area_meters_count,
     :oil_general_meters_count,
     :other_building_type,
     :other_certified,
     :pool_fuel,
     :pool_year_round,
     :propane_area_meters_count,
     :propane_general_meters_count,
     :public_housing,
     :quarantine,
     :resident_type,
     :solar_area_meters_count,
     :solar_general_meters_count,
     :sqft,
     :state_code,
     :steam_area_meters_count,
     :steam_general_meters_count,
     :street_address,
     :successful_upload_on,
     :tenant_pays_area_electric,
     :tenant_pays_area_gas,
     :tenant_pays_area_oil,
     :tenant_pays_area_propane,
     :tenant_pays_area_steam,
     :tenant_pays_area_water,
     :updated_at,
     :upload_attempt_on,
     :water_area_meters_count,
     :water_general_meters_count,
     :wegowise_id,
     :year_built,
     :zip_code]
  end
end
