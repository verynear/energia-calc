require 'rails_helper'

describe FullStructurePresenter do
  let(:audit_structure) { create(:audit_structure) }
  let(:presenter) { described_class.new(audit_structure) }
  let(:associations_hash) do
    {
      'field_values' => [],
      'sample_groups' => [],
      'substructures' => []
    }
  end

  describe '#as_json' do
    it 'returns the structure as a hash' do
      expected = audit_structure.as_json.merge(associations_hash)
      expect(presenter.as_json).to eq expected
    end

    it 'returns an associated physical structure' do
      building = create(:building)
      audit_structure.physical_structure = building
      audit_structure.name = building.name

      expected = audit_structure.as_json.merge(associations_hash)
      expected['physical_structure'] = building.as_json
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated substructures' do
      substructure = create(:audit_structure, parent_structure: audit_structure)
      substructure_json = substructure.as_json.merge(associations_hash)

      expected = audit_structure.as_json.merge(associations_hash)
      expected['substructures'] = [substructure_json]
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated sample groups' do
      sample_group = create(:sample_group, parent_structure: audit_structure)

      expected = audit_structure.as_json.merge(associations_hash)
      expected['sample_groups'] = [
        sample_group.as_json.merge('substructures' => [])
      ]
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated field values' do
      audit_field = create(:audit_field)
      audit_field_value = create(:audit_field_value,
                           audit_field: audit_field,
                           audit_structure: audit_structure)

      expected = audit_structure.as_json.merge(associations_hash)
      expected['field_values'] = [audit_field_value.as_json]
      expect(presenter.as_json).to eq expected
    end
  end
end
