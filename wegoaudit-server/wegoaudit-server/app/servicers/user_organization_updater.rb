class UserOrganizationUpdater < Generic::Strict
  attr_accessor :calc_user
  attr_reader :calc_organization

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
    calc_user.update!(calc_organization: calc_organization)
  end

  def create_or_update_organization
    @calc_organization = CalcOrganization.find_by(wegowise_id: wegowise_org['id'])

    if calc_organization
      calc_organization.update!(org_params)
    else
      @calc_organization = CalcOrganization.create!(org_params)
    end
  end

  def org_params
    {
      name: wegowise_org['name'],
      wegowise_id: wegowise_org['id']
    }
  end

  def organizations
    WegowiseClient.new(user: user).organizations
  end
  memoize :organizations

  def remove_user_from_organization
    user.update!(calc_organization: nil)
  end

  def wegowise_org
    calc_organizations.first if calc_organizations.present?
  end
  memoize :wegowise_org
end
