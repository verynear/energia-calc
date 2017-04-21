require 'rails_helper'

describe StructuresHelper do
  describe '.crumb_links' do
    let(:audit) { create(:audit) }
    let(:structure) { create(:structure, parent_structure: audit.structure) }

    it 'returns an array of link_to params for an structure' do
      params = crumb_links(audit, structure)
      expect(params).to eq [
        [audit.name, audit],
        [structure.name, [audit, structure]]
      ]
    end

    it 'returns an array of link_to params for a sample group' do
      sample_group = create(:sample_group, parent_structure: structure)
      params = crumb_links(audit, sample_group)
      expect(params).to eq [
        [audit.name, audit],
        [structure.name, [audit, structure]],
        [sample_group.name, [audit, sample_group]]
      ]
    end

    it 'returns an array of link_to params for a sample' do
      sample_group = create(:sample_group, parent_structure: structure)
      sample = create(:structure, sample_group: sample_group)
      params = crumb_links(audit, sample)
      expect(params).to eq [
        [audit.name, audit],
        [structure.name, [audit, structure]],
        [sample_group.name, [audit, sample_group]],
        [sample.name, [audit, sample]]
      ]
    end
  end
end
