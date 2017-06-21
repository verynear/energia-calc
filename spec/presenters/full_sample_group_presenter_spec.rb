require 'rails_helper'

describe FullSampleGroupPresenter do
  let(:audit_structure) { create(:audit_structure) }
  let(:sample_group) { create(:sample_group, parent_structure: audit_structure) }
  let(:presenter) { described_class.new(sample_group) }
  let(:sample_group_associations_hash) { { 'substructures' => [] } }
  let(:structure_associations_hash) do
    {
      'field_values' => [],
      'sample_groups' => [],
      'substructures' => []
    }
  end

  describe '#as_json' do
    it 'returns the sample group as json' do
      expected_hash = sample_group.as_json.merge(sample_group_associations_hash)
      expect(presenter.as_json).to eq expected_hash
    end

    it 'returns associated substructures' do
      substructure = create(:audit_structure, sample_group: sample_group)
      expected = sample_group.as_json.merge(sample_group_associations_hash)
      expected['substructures'] = [
        substructure.as_json.merge(structure_associations_hash)
      ]
      expect(presenter.as_json).to eq expected
    end
  end
end
