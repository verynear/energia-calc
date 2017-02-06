class BuildingApartmentsRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_building_id, user_id)
    building = Building.find_by(wegowise_id: wegowise_building_id)
    user = User.find(user_id)
    wego_building = WegoBuilding.new(user)
    wego_building.apartments(building.wegowise_id).each do |apartment_params|
      ApartmentImportService.execute!(params: apartment_params,
                                      building: building)
    end
  end
end
