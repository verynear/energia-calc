require 'rails_helper'

describe StructureCloneService do
  it 'sets and gets #params' do
    params = described_class.new(params: :foo).params
    expect(params).to eq :foo
  end

  it 'sets and gets #structure' do
    audit_structure = described_class.new(audit_structure: :foo).audit_structure
    expect(audit_structure).to eq :foo
  end

  describe '#execute!' do
    let(:heating_system_type) { create(:audit_strc_type, name: 'Heating System') }
    let(:existing_structure) do
      create(:audit_structure,
             name: 'My existing structure',
             audit_strc_type: heating_system_type)
    end

    it 'clones the top level structure' do
      service = described_class.new(
        params: { name: 'My cloned structure' },
        audit_structure: existing_structure
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
        audit_structure: building.audit_structure
      )
      service.execute!
      expect(service.audit_structure.physical_structure).to_not be_nil
      expect(service.cloned_structure.physical_structure).to_not be_nil
      expect(service.cloned_structure.name).to eq 'My cloned structure'
      expect(service.cloned_structure.physical_structure.name)
        .to eq 'My cloned structure'
    end

    it 'clones field values' do
      location_field = create(:audit_field, :string)
      create(:audit_field_value,
             audit_field: location_field,
             string_value: 'My location',
             audit_structure: existing_structure)
      service = described_class.new(
        params: { name: 'My cloned structure' },
        audit_structure: existing_structure
      )
      service.execute!

      expect(service.cloned_structure.audit_field_values.map(&:value)).to eq ['My location']
    end

    it 'clones sample groups' do
      common_area_type = create(:audit_strc_type,
                                name: 'Common Area',
                                parent_structure_type: heating_system_type)
      hallway_group = create(:sample_group,
                             name: 'My hallways',
                             parent_structure: existing_structure,
                             audit_strc_type: common_area_type)
      service = described_class.new(
        params: { name: 'My cloned structure' },
        audit_structure: existing_structure
      )
      service.execute!
      expect(service.cloned_structure.sample_groups.map(&:name)).to eq ['My hallways']
    end

    it 'clones substructures' do
      controls_structure_type = create(:audit_strc_type,
                                       name: 'Controls',
                                       parent_structure_type: heating_system_type)
      controls_structure = create(:audit_structure,
                                  name: 'Heating system controls',
                                  parent_structure: existing_structure)

      service = described_class.new(
        params: { name: 'My cloned structure' },
        audit_structure: existing_structure
      )
      service.execute!

      expect(service.cloned_structure.substructures.map(&:name))
        .to eq ['Heating system controls']
    end
  end
end
