require 'rails_helper'

describe AuditStructuresHelper do
  describe '.crumb_links' do
    let(:audit) { create(:audit) }
    let(:audit_structure) { create(:audit_structure, parent_structure: audit.audit_structure) }

    it 'returns an array of link_to params for an structure' do
      params = crumb_links(audit, audit_structure)
      expect(params).to eq [
        [audit.name, audit],
        [audit_structure.name, [audit, audit_structure]]
      ]
    end

    it 'returns an array of link_to params for a sample group' do
      sample_group = create(:sample_group, parent_structure: audit_structure)
      params = crumb_links(audit, sample_group)
      expect(params).to eq [
        [audit.name, audit],
        [audit_structure.name, [audit, audit_structure]],
        [sample_group.name, [audit, sample_group]]
      ]
    end

    it 'returns an array of link_to params for a sample' do
      sample_group = create(:sample_group, parent_structure: audit_structure)
      sample = create(:audit_structure, sample_group: sample_group)
      params = crumb_links(audit, sample)
      expect(params).to eq [
        [audit.name, audit],
        [audit_structure.name, [audit, audit_structure]],
        [sample_group.name, [audit, sample_group]],
        [sample.name, [audit, sample]]
      ]
    end
  end
end
