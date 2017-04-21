require 'rails_helper'

describe Wegoaudit::Audit do
  describe '#structures=' do
    let(:json) do
      [{ id: 1, 'substructures' => [{ id: 3 }] },
       { id: 2 }]
    end
    let(:audit) { described_class.new(structures: json) }

    it 'creates Structure instances' do
      expect(audit.structures.map(&:class))
        .to eq([Wegoaudit::Structure, Wegoaudit::Structure])
    end

    it 'passes values to structures' do
      expect(audit.structures.map(&:id)).to eq([1, 2])
      expect(audit.structures.map(&:id)).to eq([1, 2])
    end

    it 'creates substructures' do
      expect(audit.structures[0].substructures.map(&:id)).to eq([3])
      expect(audit.structures[1].substructures.map(&:id)).to eq([])
    end

    it 'sets a parent attribute on substructures' do
      structure1 = audit.structures[0]
      structure2 = audit.structures[1]
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
    expect(audit.flattened_structures.map(&:id)).to eq([1, 3, 2])
  end
end
