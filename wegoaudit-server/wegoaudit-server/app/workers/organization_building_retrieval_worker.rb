class OrganizationBuildingRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_organization_id, user_id = nil)
    organization = Organization.find_by(wegowise_id: wegowise_organization_id)
    org_id = organization.wegowise_id
    user = User.find(user_id)
    wego_building = WegoBuilding.new(user)
    wego_building.index.each do |building_params|
      BuildingImportService.execute!(params: building_params,
                                     organization: organization)
    end
  end
end
