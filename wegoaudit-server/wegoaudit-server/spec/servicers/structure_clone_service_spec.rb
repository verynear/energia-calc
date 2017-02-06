require 'rails_helper'

describe StructureCloneService do
  it 'sets and gets #params' do
    params = described_class.new(params: :foo).params
    expect(params).to eq :foo
  end

  it 'sets and gets #structure' do
    structure = described_class.new(structure: :foo).structure
    expect(structure).to eq :foo
  end

  describe '#execute!' do
    let(:heating_system_type) { create(:structure_type, name: 'Heating System') }
    let(:existing_structure) do
      create(:structure,
             name: 'My existing structure',
             structure_type: heating_system_type)
    end

    it 'clones the top level structure' do
      service = described_class.new(
        params: { name: 'My cloned structure' },
        structure: existing_structure
      )
      service.execute!
      expect(service.cloned_structure).to be_persisted
      expect(service.cloned_structure.name).to eq 'My cloned structure'
    end

    it 'clones a physical structure, if present' do
      building = create(:building_with_structure,
                        nickname: 'My existing structure')
      service = described_class.new(
        params: { name: 'My cloned structure' },
        structure: building.structure
      )
      service.execute!
      expect(service.structure.physical_structure).to_not be_nil
      expect(service.cloned_structure.physical_structure).to_not be_nil
      expect(service.cloned_structure.name).to eq 'My cloned structure'
      expect(service.cloned_structure.physical_structure.name)
        .to eq 'My cloned structure'
    end

    it 'clones field values' do
      location_field = create(:field, :string)
      create(:field_value,
             field: location_field,
             string_value: 'My location',
             structure: existing_structure)
      service = described_class.new(
        params: { name: 'My cloned structure' },
        structure: existing_structure
      )
      service.execute!

      expect(service.cloned_structure.field_values.map(&:value)).to eq ['My location']
    end

    it 'clones sample groups' do
      common_area_type = create(:structure_type,
                                name: 'Common Area',
                                parent_structure_type: heating_system_type)
      hallway_group = create(:sample_group,
                             name: 'My hallways',
                             parent_structure: existing_structure,
                             structure_type: common_area_type)
      service = described_class.new(
        params: { name: 'My cloned structure' },
        structure: existing_structure
      )
      service.execute!
      expect(service.cloned_structure.sample_groups.map(&:name)).to eq ['My hallways']
    end

    it 'clones substructures' do
      controls_structure_type = create(:structure_type,
                                       name: 'Controls',
                                       parent_structure_type: heating_system_type)
      controls_structure = create(:structure,
                                  name: 'Heating system controls',
                                  parent_structure: existing_structure)

      service = described_class.new(
        params: { name: 'My cloned structure' },
        structure: existing_structure
      )
      service.execute!

      expect(service.cloned_structure.substructures.map(&:name))
        .to eq ['Heating system controls']
    end
  end
end
