class UserOrganizationUpdater < Generic::Strict
  attr_accessor :user
  attr_reader :organization

  def execute
    if wegowise_org
      create_or_update_organization
      add_user_to_organization
    else
      remove_user_from_organization
    end
  end

  private

  def add_user_to_organization
    user.update!(organization: organization)
  end

  def create_or_update_organization
    @organization = Organization.find_by(wegowise_id: wegowise_org['id'])

    if organization
      organization.update!(org_params)
    else
      @organization = Organization.create!(org_params)
    end
  end

  def org_params
    {
      name: wegowise_org['name'],
      wegowise_id: wegowise_org['id']
    }
  end

  def remove_user_from_organization
    user.update!(organization: nil)
  end

  def wegowise_org
    organizations.first if organizations.present?
  end
  memoize :wegowise_org
end
