require 'rails_helper'

describe TempStructure do
  describe '#containing_physical_structure' do
    it 'climbs up structure chain to find a physical structure' do
      structure1 = described_class.new(wegowise_id: 1)
      structure2 = described_class.new(parent_structure: structure1)
      structure3 = described_class.new(parent_structure: structure2)
      expect(structure3.containing_physical_structure).to eq(structure1)
    end

    it "returns nil if it can't find a physical structure" do
      structure1 = described_class.new
      structure2 = described_class.new(parent_structure: structure1)
      structure3 = described_class.new(parent_structure: structure2)
      expect(structure3.containing_physical_structure).to eq(nil)
    end
  end

  describe '#location' do
    it 'is nil if structure has wegowise_id' do
      expect(described_class.new(wegowise_id: 1).location).to eq(nil)
    end

    it 'is the sample group name if structure has sample_group_id' do
      sample_group_json = [
        { id: 'foo', name: 'sample group 1' },
        { id: 'bar', name: 'sample group 2' }
      ]
      audit = TempAudit.new(sample_groups: sample_group_json)

      temp_structure = described_class.new(sample_group_id: 'bar', audit: audit)
      expect(temp_structure.location).to eq 'sample group 2'
    end

    it 'climbs up structure chain to find a physical structure' do
      structure1 = described_class.new(wegowise_id: 1, name: 'Building A')
      structure2 = described_class.new(parent_structure: structure1)
      structure3 = described_class.new(parent_structure: structure2)
      expect(structure3.location).to eq('Building A')
    end

    it 'is "Top Level" if there is no physical structure' do
      structure1 = described_class.new
      structure2 = described_class.new(parent_structure: structure1)
      structure3 = described_class.new(parent_structure: structure2)
      expect(structure3.location).to eq('Top level')
    end
  end
end
