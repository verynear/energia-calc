require 'rails_helper'

describe ApartmentImportService do
  let(:building) { create(:building_with_structure) }
  let!(:apartment_structure_type) { create(:apartment_structure_type) }
  let(:service) do
    ApartmentImportService.new(params: params, building: building)
  end

  it 'creates an apartment' do
    expect { service.execute }.to change { Apartment.count }.by 1
  end

  it 'associates the apartment with the building' do
    expect { service.execute }.to change { building.apartments.count }.by 1
  end

  it 'associates the apartment structure with the building structure' do
    service.execute
    apartment = service.apartment
    expect(apartment.structure.parent_structure_id)
      .to eq building.structure.id
  end

  it 'updates the apartment if it already exists' do
    service.execute
    service.apartment.update_attributes(unit_number: '202b')
    expect { service.execute }
      .to change { service.apartment.unit_number }.from('202b')
                                                  .to('101a')
  end

  it 'does not create an apartment if one exists' do
    service.execute
    expect { service.execute }
      .to change { Apartment.count }.by 0
  end

  def params
    { 'id' => 345,
      'n_bedrooms' => 2,
      'quarantine' => false,
      'building_id' => building.wegowise_id,
      'unit_number' => '101a',
      'sqft' => 1000 }
  end
end

