class OrganizationMemberRetrievalWorker
  include Sidekiq::Worker

  def perform(wegowise_organization_id, user_id)
    organization = Organization.find_by(wegowise_id: wegowise_organization_id)
    org_id = organization.wegowise_id
    user = User.find(user_id)
    wego_organization = WegoOrganization.new(user)
    wego_organization.memberships(org_id).each do |member_params|
      MembershipImportService.execute!(params: member_params,
                                       organization: organization)
    end
  end
end
