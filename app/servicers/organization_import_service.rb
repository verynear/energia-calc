class OrganizationImportService < BaseServicer
  attr_accessor :organization, :params, :user

  def execute!
    @params = WegoHash.new(@params)
    create_or_update_owner
    create_or_update_organization
  end

  private

  def create_or_update_organization
    @organization = Organization.find_by(wegowise_id:
                                           organization_params[:wegowise_id])
    return @organization.update_attributes(organization_params) if @organization
    @organization = Organization.create!(organization_params)
  end

  def create_or_update_owner
    @owner = User.find_by(wegowise_id: owner_params[:wegowise_id])
    return @owner.update_attributes(owner_params) if @owner
    @owner = User.create!(owner_params)
  end

  def user_id
    return user.id if user
    @organization.owner.id
  end

  def organization_params
    @organization_params ||= params.except(:owner).merge(owner: @owner)
  end

  def owner_params
    @owner_params ||= params[:owner].except(:person_id)
  end
end
