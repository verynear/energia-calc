require 'rails_helper'

describe AuditStructure do
  it { should have_many(:sample_groups).with_foreign_key(:parent_structure_id) }
  it { should have_many :substructures }
  it { should have_many :audit_field_values }
  it { should belong_to :audit_strc_type }
  it { should belong_to :parent_structure }

  describe '.value_for_field' do
    let(:structure) { create(:audit_structure) }
    let(:audit_field) { create(:audit_field) }

    it 'returns nil if there are no field_values' do
      expect(structure.value_for_field(audit_field)).to be_nil
    end

    it 'returns nil if a field_value does not exist for the field' do
      audit_field_value = create(:audit_field_value, audit_field: create(:audit_field),
                                         audit_structure: structure)
      expect(structure.value_for_field(audit_field)).to be_nil
    end

    it 'returns a field_value if one exists for the field' do
      audit_field_value = create(:audit_field_value, audit_field: audit_field,
                                          audit_structure: structure)
      expect(structure.value_for_field(audit_field)).to eq audit_field_value
    end
  end

  describe '#audit' do
    it 'returns the audit if this structure is associated with one' do
      audit_structure = create(:audit_structure)
      audit = create(:audit, audit_structure_id: audit_structure.id)
      expect(audit_structure.audit).to eq audit
    end

    it 'returns nil for other structures' do
      audit_structure = AuditStructure.new
      expect(audit_structure.audit).to be_nil
    end
  end

  describe '#parent_audit' do
    it 'returns the parent object of an audit structure' do
      audit = create(:audit)
      expect(audit.audit_structure.parent_audit).to eq audit
    end

    it 'returns the parent audit of a structure' do
      audit = create(:audit)
      audit_structure = create(:audit_structure, parent_structure: audit.audit_structure)
      expect(audit_structure.parent_audit).to eq audit
    end

    it 'traverses up a structure hierarchy to find the audit' do
      audit = create(:audit)
      parent_structure = create(:audit_structure, parent_structure: audit.audit_structure)
      audit_structure = create(:audit_structure, parent_structure: parent_structure)
      expect(audit_structure.parent_audit).to eq audit
    end

    it 'traverses up a sample group hierarchy to find the audit' do
      audit = create(:audit)
      sample_group = create(:sample_group, parent_structure: audit.audit_structure)
      audit_structure = create(:audit_structure, sample_group: sample_group)
      expect(audit_structure.parent_audit).to eq audit
    end
  end

  describe '#parent_object' do
    let(:audit_structure) { build(:audit_structure) }
    let(:sample_group) { build(:sample_group, parent_structure: audit_structure) }
    let(:sample) { build(:audit_structure, sample_group: sample_group) }

    it 'returns an associated sample group' do
      expect(sample.parent_object).to eq sample_group
    end

    it 'returns an associated parent structure' do
      expect(sample_group.parent_object).to eq audit_structure
    end

    it 'returns an audit if this structure is associated with one' do
      audit_structure = create(:audit_structure)
      audit = create(:audit, audit_structure_id: audit_structure.id)
      expect(audit_structure.parent_object).to eq audit
    end
  end

  describe '#short_description' do
    let(:audit_structure) { AuditStructure.new }
    let(:building) { mock_model(Building) }
    let(:audit_strc_type) { build(:audit_strc_type) }

    it 'returns the structure type + structure name' do
      audit_strc_type = build(:audit_strc_type)
      audit_structure.audit_strc_type = audit_strc_type
      audit_structure.name = '123 Blue Lane'
      expect(audit_structure.short_description).to eq(
        "#{audit_strc_type.name} - 123 Blue Lane")
    end

    it 'returns the short_description of an associated physical_structure' do
      expect(building).to receive(:short_description).and_return('Foo - 123')
      audit_structure.physical_structure = building
      expect(audit_structure.short_description).to eq 'Foo - 123'
    end
  end
end
