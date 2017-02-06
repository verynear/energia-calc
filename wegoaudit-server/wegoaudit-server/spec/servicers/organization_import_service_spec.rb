require 'rails_helper'

describe OrganizationImportService do
  let(:service) { OrganizationImportService.new(params: params) }

  it 'converts id keys of params to wegowise_id' do
    service.execute!
    expect(service.params['id']).to be_nil
    expect(service.params['wegowise_id']).to eq 18
    expect(service.params['owner']['id']).to be_nil
    expect(service.params['owner']['wegowise_id']).to eq 4034
  end

  it 'creates the owner if the owner does not exist' do
    expect { service.execute! }.to change { User.count }.by 1
  end

  it 'creates an organization if it does not exist' do
    expect { service.execute! }.to change { Organization.count }.by 1
  end

  it 'updates the organization if it exists' do
    own_params = replace_id(owner_params).except('person_id')
    owner = User.create(own_params)
    org_params = replace_id(organization_params).merge(owner: owner)
    org_params['name'] = 'CPI USER'
    org = Organization.create(org_params)
    service.execute!
    expect(service.organization.owner.first_name).to eq('Jane')
  end

  it 'updates the owner if it exists' do
    own_params = replace_id(owner_params).except('person_id')
    own_params['first_name'] = 'Jack'
    owner = User.create(own_params)
    org_params = replace_id(organization_params).merge(owner: owner)
    org = Organization.create(org_params)
    service.execute!
    expect(service.organization.owner.first_name).to eq('Jane')
  end

  it 'queues member retrieval' do
    user = create(:user, WegoHash.new(owner_params).except('person_id'))
    id = organization_params['id']
    expect(OrganizationMemberRetrievalWorker)
      .to receive(:perform_async).with(organization_params['id'],
                                       user.id)
    service.execute!
  end

  def params
    organization_params.merge(owner: owner_params)
  end

  def organization_params
    { 'id' => 18,
      'name' => 'API Users' }
  end

  def owner_params
    { 'id' => 4034,
      'username' => 'apiuser',
      'phone' => nil,
      'person_id' => 3261,
      'first_name' => 'Jane',
      'last_name' => 'Doe',
      'organization' => nil }
  end

  def replace_id(hash)
    hash['wegowise_id'] = hash.delete('id')
    hash
  end
end
