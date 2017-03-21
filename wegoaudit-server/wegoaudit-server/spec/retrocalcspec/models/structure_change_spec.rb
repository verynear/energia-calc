require 'rails_helper'

describe StructureChange do
  it { is_expected.to belong_to(:measure_selection) }
  it { is_expected.to delegate_method(:audit).to(:measure_selection) }

  specify '#original_structure finds the first non-proposed structure' do
    structure1 = Structure.new(proposed: true)
    structure2 = Structure.new(proposed: false)
    structure3 = Structure.new(proposed: true)
    structure_change = described_class.new(
      structures: [structure1, structure2, structure3])
    expect(structure_change.original_structure).to eq(structure2)
  end

  specify '#proposed_structure finds the first non-proposed structure' do
    structure1 = Structure.new(proposed: false)
    structure2 = Structure.new(proposed: true)
    structure3 = Structure.new(proposed: false)
    structure_change = described_class.new(
      structures: [structure1, structure2, structure3])
    expect(structure_change.proposed_structure).to eq(structure2)
  end
end
