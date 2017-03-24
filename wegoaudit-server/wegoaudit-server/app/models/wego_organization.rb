class WegoOrganization
  # include WegowiseClient

  attr_accessor :organization_id, :owner, :user

  def initialize(user, organization_id = nil)
    @user = user
  end

  def memberships(organization_id)
    raise 'organization_id must be specified' unless organization_id
    make_wego_call(:get, "#{index_path}/#{organization_id}/members")
  end

  def object_base_path
    'organization'
  end
end
