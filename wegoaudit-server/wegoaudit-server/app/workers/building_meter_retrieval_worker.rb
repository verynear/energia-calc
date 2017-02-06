class BuildingMeterRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_building_id, user_id = nil)
    building = Building.find_by(wegowise_id: wegowise_building_id)
    if user_id
      user = User.find(user_id)
    else
      organization = building.organizations.first
      user = organization.owner
    end

    wego_building = WegoBuilding.new(user)
    wego_building.meters(building.wegowise_id).each do |meter_params|
      MeterImportService.execute!(params: meter_params,
                                  user: user)
    end
  end
end
