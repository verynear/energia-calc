require 'rails_helper'

describe AuditStrcType do
  it { should have_many :child_substructure_types }
  it { should have_many :audit_structures }
  it { should have_many :groupings }
  it { should have_many :substructure_types }
  it { should have_many :child_substructure_types }

  it 'does not allow changing api_name' do
    audit_strc_type = create(:audit_strc_type, name: 'This is my Name')
    audit_strc_type.api_name = 'foo'
    expect(audit_strc_type).to_not be_valid
    expect(audit_strc_type.errors[:api_name]).to eq(["Can't change api_name"])
  end

  it 'sets its api_name based on name' do
    audit_strc_type = create(:audit_strc_type, name: 'This is my Name')
    expect(audit_strc_type.api_name).to eq('this_is_my_name')
  end

  specify "#grandparent_structure_type gets its parent's parent" do
    parent_structure_type = mock_model(
      AuditStrcType,
      parent_structure_type: 'gramps')
    audit_strc_type = build(
      :audit_strc_type,
      name: 'This is my Name',
      parent_structure_type: parent_structure_type
    )
    expect(audit_strc_type.grandparent_structure_type).to eq('gramps')
  end

  describe '#genus_structure_type' do
    let!(:parent_structure_type) do
      mock_model(AuditStructureType, genus_structure_type?: true)
    end
    let!(:audit_strc_type) do
      build(:audit_strc_type,
            parent_structure_type: parent_structure_type,
            primary: true)
    end

    it 'is the structure_type itself if primary: false' do
      audit_strc_type = build(:audit_strc_type, primary: false)
      expect(audit_strc_type.genus_structure_type).to eq(audit_strc_type)
    end

    it 'is the parent if the parent is top level' do
      expect(audit_strc_type.genus_structure_type).to eq(parent_structure_type)
    end

    it 'is the grandparent if the grandparent is top level' do
      gramps = mock_model(AuditStructureType, genus_structure_type?: true)
      allow(parent_structure_type).to receive(:genus_structure_type?)
        .and_return(false)
      allow(parent_structure_type).to receive(:parent_structure_type)
        .and_return(gramps)
      expect(audit_strc_type.genus_structure_type).to eq(gramps)
    end

    it 'is the structure type itself otherwise' do
      gramps = mock_model(AuditStructureType, genus_structure_type?: false)
      allow(parent_structure_type).to receive(:genus_structure_type?)
        .and_return(false)
      allow(parent_structure_type).to receive(:parent_structure_type)
        .and_return(gramps)
      expect(audit_strc_type.genus_structure_type).to eq(audit_strc_type)
    end
  end

  describe '#has_physical_structure?' do
    it 'returns false if physical_structure_type is nil' do
      audit_strc_type = described_class.new(physical_structure_type: nil)
      expect(audit_strc_type.has_physical_structure?).to eq false
    end

    it 'returns true if physical_structure_type is not nil' do
      audit_strc_type = described_class.new(physical_structure_type: 'Building')
      expect(audit_strc_type.has_physical_structure?).to eq true
    end
  end

  describe '#physical_structure_class' do
    it 'returns nil if physical_structure_type is nil' do
      audit_strc_type = described_class.new(physical_structure_type: nil)
      expect(audit_strc_type.physical_structure_class).to eq nil
    end

    it 'returns a class if the physical_structure_type is a class' do
      audit_strc_type = described_class.new(physical_structure_type: 'Building')
      expect(audit_strc_type.physical_structure_class).to eq Building
    end
  end
  describe '#sampleable?' do
    it { expect(described_class.new(name: 'Apartment')).to be_sampleable }
    it { expect(described_class.new(name: 'Building')).to_not be_sampleable }
  end
end
