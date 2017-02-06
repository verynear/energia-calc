class BuildingRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_building_id, user_id = nil)
    user = User.find(user_id)
    organization = user.organizations.first
    wego_building = WegoBuilding.new(organization.owner)
    params = wego_building.show(wegowise_building_id)
    BuildingImportService.execute!(params: params,
                                   organization: organization)
  end
end
