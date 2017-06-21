require 'rails_helper'

describe TempAudit do
  describe '#structures=' do
    let(:json) do
      [{ id: 1, 'substructures' => [{ id: 3 }] },
       { id: 2 }]
    end
    let(:audit) { described_class.new(structures: json) }

    it 'creates Structure instances' do
      expect(temp_audit.structures.map(&:class))
        .to eq([TempStructure, TempStructure])
    end

    it 'passes values to structures' do
      expect(temp_audit.structures.map(&:id)).to eq([1, 2])
      expect(temp_audit.structures.map(&:id)).to eq([1, 2])
    end

    it 'creates substructures' do
      expect(temp_audit.structures[0].substructures.map(&:id)).to eq([3])
      expect(temp_audit.structures[1].substructures.map(&:id)).to eq([])
    end

    it 'sets a parent attribute on substructures' do
      structure1 = temp_audit.structures[0]
      structure2 = temp_audit.structures[1]
      structure3 = structure1.substructures[0]

      expect(structure1.parent_structure).to eq(nil)
      expect(structure2.parent_structure).to eq(nil)
      expect(structure3.parent_structure).to eq(structure1)
    end
  end

  specify '#flattened_structures returns a flattened set of structures' do
    json = [{ id: 1, 'substructures' => [{ id: 3 }] },
            { id: 2 }]
    audit = described_class.new(structures: json)
    expect(temp_audit.flattened_structures.map(&:id)).to eq([1, 3, 2])
  end
end
