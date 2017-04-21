require 'rails_helper'

describe FullStructurePresenter do
  let(:structure) { create(:structure) }
  let(:presenter) { described_class.new(structure) }
  let(:associations_hash) do
    {
      'field_values' => [],
      'sample_groups' => [],
      'substructures' => []
    }
  end

  describe '#as_json' do
    it 'returns the structure as a hash' do
      expected = structure.as_json.merge(associations_hash)
      expect(presenter.as_json).to eq expected
    end

    it 'returns an associated physical structure' do
      building = create(:building)
      structure.physical_structure = building
      structure.name = building.name

      expected = structure.as_json.merge(associations_hash)
      expected['physical_structure'] = building.as_json
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated substructures' do
      substructure = create(:structure, parent_structure: structure)
      substructure_json = substructure.as_json.merge(associations_hash)

      expected = structure.as_json.merge(associations_hash)
      expected['substructures'] = [substructure_json]
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated sample groups' do
      sample_group = create(:sample_group, parent_structure: structure)

      expected = structure.as_json.merge(associations_hash)
      expected['sample_groups'] = [
        sample_group.as_json.merge('substructures' => [])
      ]
      expect(presenter.as_json).to eq expected
    end

    it 'returns associated field values' do
      field = create(:field)
      field_value = create(:field_value,
                           field: field,
                           structure: structure)

      expected = structure.as_json.merge(associations_hash)
      expected['field_values'] = [field_value.as_json]
      expect(presenter.as_json).to eq expected
    end
  end
end
