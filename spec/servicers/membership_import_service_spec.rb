require 'rails_helper'

describe MembershipImportService do
  let(:service) { MembershipImportService.new(params: params) }
  let!(:organization) { create(:organization) }

  it 'converts id keys of params to wegowise_id' do
    service.execute!
    expect(service.params['id']).to be_nil
    expect(service.params['wegowise_id']).to eq 18
    expect(service.params['user']['id']).to be_nil
    expect(service.params['user']['wegowise_id']).to eq 4034
  end

  it 'creates the user if the user does not exist' do
    expect { service.execute! }.to change { User.count }.by 1
  end

  it 'creates a membership if it does not exist' do
    expect { service.execute! }.to change { Membership.count }.by 1
  end

  it 'only creates 1 membership even if called multiple times' do
    expect { 2.times { service.execute! } }.to change { Membership.count }.by 1
  end

  it 'updates the membership if it exists' do
    u_params = WegoHash.new(user_params.except('person_id'))
    user = User.create(u_params)
    m_params = WegoHash.new(membership_params.merge(user: user,
                                                    organization: organization))
    m_params['role'] = 'admin'
    Membership.create(m_params)
    service.execute!
    expect(service.membership.role).to eq('member')
  end

  it 'updates the user if it exists' do
    u_params = WegoHash.new(user_params.except('person_id'))
    u_params['first_name'] = 'Jack'
    user = User.create(u_params)
    m_params = WegoHash.new(membership_params.merge(user: user,
                                                    organization: organization))
    service.execute!
    expect(service.membership.user.first_name).to eq('Jane')
  end

  def params
    membership_params.merge(user: user_params)
  end

  def membership_params
    { 'id' => 18,
      'role' => Organization::MEMBER,
      'access' => AccessLevel::EDIT,
      'organization_id' => organization.wegowise_id }
  end

  def user_params
    { 'id' => 4034,
      'username' => 'apiuser',
      'phone' => nil,
      'person_id' => 3261,
      'first_name' => 'Jane',
      'last_name' => 'Doe',
      'organization' => nil }
  end
end
