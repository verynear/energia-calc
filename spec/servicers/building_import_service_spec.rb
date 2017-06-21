require 'rails_helper'

describe BuildingImportService do
  let(:organization) { create(:organization) }
  let!(:audit_strc_type) do
    create(:audit_strc_type, name: 'Building',
                            physical_structure_type: 'Building')
  end
  let(:service) do
    BuildingImportService.new(params: params,
                              organization: organization)
  end

  it 'creates a building' do
    expect { service.execute }.to change { Building.count }.by 1
  end

  it 'associates the building with the organization' do
    expect { service.execute }.to change { organization.buildings.count }.by 1
  end

  it 'updates the building if it already exists' do
    service.execute
    service.building.update_attributes(nickname: '10 Albatross Lane')
    expect { service.execute }
      .to change { service.building.nickname }.from('10 Albatross Lane')
                                              .to('10 Greene Street')
  end

  it 'does not create a building if one exists' do
    service.execute
    expect { service.execute }
      .to change { Building.count }.by 0
  end

  it 'does not reassociate the building to the organizaiton' do
    service.execute
    expect { service.execute }
      .to change { organization.buildings.count }.by 0
  end

  it 'creates a structure for the building' do
    expect { service.execute }.to change { AuditStructure.count }.by 1
  end

  it "removes the basement key if it's value is nil" do
    updated_params = params.except('basement')
    updated_params['basement'] = nil
    service.params = updated_params
    expect { service.execute }.not_to raise_error
  end

  def params
    { 'conditioned_sqft' => 37,
      'id' => 34174,
      'nickname' => '10 Greene Street',
      'n_stories' => 1,
      'n_apartments' => 1,
      'sqft' => 937,
      'year_built' => 1942,
      'notes' => '',
      'type' => 'sf_detached',
      'basement' => { 'sqft' => 900,
                      'conditioned' => false},
      'cooling' => { 'system' => 'window_ac' },
      'heating' => { 'fuel' => 'Oil',
                     'system' => 'hot_water_boiler' },
      'hot_water' => { 'fuel' => 'Gas',
                       'system' => 'indirect_with_heat'},
      'location' => { 'city' => 'Troy',
                      'climate_zone' => nil,
                      'country' => 'United States',
                      'county' => 'Rensselaer County',
                      'state' => 'NY',
                      'street_address' => '10 Greene Street',
                      'zip_code' => '12180'
                    }
    }
  end
end
