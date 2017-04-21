class MembershipImportService < BaseServicer
  attr_accessor :membership, :organization, :params

  def execute!
    @params = WegoHash.new(@params)
    find_organization
    find_or_create_user
    find_or_create_membership
  end

  private

  def find_organization
    return if @organization.present?
    @organization = Organization.find_by(wegowise_id: params[:organization_id])
  end

  def find_or_create_user
    @user = User.find_by(wegowise_id: user_params[:wegowise_id])
    return @user.update_attributes(user_params) if @user.present?
    @user = User.create!(user_params)
  end

  def find_or_create_membership
    @membership = Membership.find_by(user: @user, organization: @organization)
    return @membership.update_attributes(membership_params) if @membership.present?
    @membership = Membership.create!(membership_params)  end

  def user_params
    params[:user].except(:person_id)
  end

  def membership_params
    params.except(:user, :organization_id)
          .merge(organization: @organization,
                 user: @user)
  end
end
