class OrganizationsController < SecuredController
  before_filter :load_organization, only: [:download_buildings, :show]

  def index
    @organizations = Organization.all
  end

  def show
  end

  def download
    wego_organization = WegoOrganization.new(current_user)
    organizations = wego_organization.index

    organizations.each do |organization_params|
      OrganizationImportService.execute!(params: organization_params,
                                         user: current_user)
    end
    redirect_to organizations_path
  end

  def download_buildings
    OrganizationBuildingRetrievalWorker.perform_async(@organization.wegowise_id,
                                                      current_user.id)
    flash[:notice] = 'Building updates queued for background retrieval'
    redirect_to organizations_path
  end

  private

  def load_organization
    @organization = Organization.find(params[:id])
  end
end
