require 'rails_helper'

describe Structure do
  it { should have_many(:sample_groups).with_foreign_key(:parent_structure_id) }
  it { should have_many :substructures }
  it { should have_many :field_values }
  it { should belong_to :structure_type }
  it { should belong_to :parent_structure }

  describe '.value_for_field' do
    let(:structure) { create(:structure) }
    let(:field) { create(:field) }

    it 'returns nil if there are no field_values' do
      expect(structure.value_for_field(field)).to be_nil
    end

    it 'returns nil if a field_value does not exist for the field' do
      field_value = create(:field_value, field: create(:field),
                                         structure: structure)
      expect(structure.value_for_field(field)).to be_nil
    end

    it 'returns a field_value if one exists for the field' do
      field_value = create(:field_value, field: field,
                                          structure: structure)
      expect(structure.value_for_field(field)).to eq field_value
    end
  end

  describe '#audit' do
    it 'returns the audit if this structure is associated with one' do
      structure = create(:structure)
      audit = create(:audit, structure_id: structure.id)
      expect(structure.audit).to eq audit
    end

    it 'returns nil for other structures' do
      structure = Structure.new
      expect(structure.audit).to be_nil
    end
  end

  describe '#parent_audit' do
    it 'returns the parent object of an audit structure' do
      audit = create(:audit)
      expect(audit.structure.parent_audit).to eq audit
    end

    it 'returns the parent audit of a structure' do
      audit = create(:audit)
      structure = create(:structure, parent_structure: audit.structure)
      expect(structure.parent_audit).to eq audit
    end

    it 'traverses up a structure hierarchy to find the audit' do
      audit = create(:audit)
      parent_structure = create(:structure, parent_structure: audit.structure)
      structure = create(:structure, parent_structure: parent_structure)
      expect(structure.parent_audit).to eq audit
    end

    it 'traverses up a sample group hierarchy to find the audit' do
      audit = create(:audit)
      sample_group = create(:sample_group, parent_structure: audit.structure)
      structure = create(:structure, sample_group: sample_group)
      expect(structure.parent_audit).to eq audit
    end
  end

  describe '#parent_object' do
    let(:structure) { build(:structure) }
    let(:sample_group) { build(:sample_group, parent_structure: structure) }
    let(:sample) { build(:structure, sample_group: sample_group) }

    it 'returns an associated sample group' do
      expect(sample.parent_object).to eq sample_group
    end

    it 'returns an associated parent structure' do
      expect(sample_group.parent_object).to eq structure
    end

    it 'returns an audit if this structure is associated with one' do
      structure = create(:structure)
      audit = create(:audit, structure_id: structure.id)
      expect(structure.parent_object).to eq audit
    end
  end

  describe '#short_description' do
    let(:structure) { Structure.new }
    let(:building) { mock_model(Building) }
    let(:structure_type) { build(:structure_type) }

    it 'returns the structure type + structure name' do
      structure_type = build(:structure_type)
      structure.structure_type = structure_type
      structure.name = '123 Blue Lane'
      expect(structure.short_description).to eq(
        "#{structure_type.name} - 123 Blue Lane")
    end

    it 'returns the short_description of an associated physical_structure' do
      expect(building).to receive(:short_description).and_return('Foo - 123')
      structure.physical_structure = building
      expect(structure.short_description).to eq 'Foo - 123'
    end
  end
end
