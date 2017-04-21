# This service queues all OrganizationBuildingRetrievalWorker jobs for
# organizations that we know about.
#
# If the owner has not yet authenticated against WegoWise, it will also select
# the first authenticated user it can find from the organization's list of
# members.
class QueueOrganizationBuildingsService < BaseServicer
  def execute!
    Organization.all.each do |organization|
      queue_organization(organization)
    end
  end

  private

  def queue_organization(organization)
    wegowise_id = organization.wegowise_id
    user_id = first_authenticated_user(organization)

    if user_id
      OrganizationBuildingRetrievalWorker.perform_async(wegowise_id, user_id)
    else
      Rails.logger.info "No authenticated users found for organization
                         #{organization.name}".squish
    end
  end

  def first_authenticated_user(organization)
    if organization.owner.has_authenticated?
      user = organization.owner
    else
      user = organization.users.authenticated.first
    end

    user.id if user
  end
end
