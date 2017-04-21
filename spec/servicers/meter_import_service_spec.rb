require 'rails_helper'

describe MeterImportService do
  let(:organization) { create(:organization) }
  let(:user) { organization.owner }
  let(:structure) { create(:building_with_structure) }
  let(:service) do
    MeterImportService.new(params: params,
                           user: user)
  end

  it 'creates a meter' do
    expect { service.execute }.to change { Meter.count }.by 1
  end

  it 'updates the meter if it already exists' do
    service.execute
    service.meter.update_attributes(n_buildings: 20)
    expect { service.execute }
      .to change { service.meter.n_buildings }.from(20)
                                              .to(1)
  end

  it 'does not create a meter if one exists' do
    service.execute
    expect { service.execute }
      .to change { Meter.count }.by 0
  end

  it 'enqueues metering imports' do
    id = params['id']
    expect(MeteringRetrievalWorker)
      .to receive(:perform_async).with(params['id'], user.id)
    service.execute!
  end

  it 'raises an error if a user without a token is specified' do
    service.user.token = nil
    expect { service.execute }
      .to raise_error RuntimeError, "An organization or user that has allowed access to
                       Wegowise must be included in the initialization
                       parameters.".squish
  end

  def params
    { 'buildings_count' => 1,
      'coverage' => 'common',
      'data_type' => 'Electric',
      'for_heating' => false,
      'id' => 117902,
      'notes' => '',
      'scope' => 'BuildingMeter',
      'utility_company' => { 'id' => nil,
                             'name' => "Cohoes Electric" } }
  end
end
