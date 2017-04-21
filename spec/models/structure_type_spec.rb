require 'rails_helper'

describe StructureType do
  it { should have_many :child_substructure_types }
  it { should have_many :structures }
  it { should have_many :groupings }
  it { should have_many :substructure_types }
  it { should have_many :child_substructure_types }

  it 'does not allow changing api_name' do
    structure_type = create(:structure_type, name: 'This is my Name')
    structure_type.api_name = 'foo'
    expect(structure_type).to_not be_valid
    expect(structure_type.errors[:api_name]).to eq(["Can't change api_name"])
  end

  it 'sets its api_name based on name' do
    structure_type = create(:structure_type, name: 'This is my Name')
    expect(structure_type.api_name).to eq('this_is_my_name')
  end

  specify "#grandparent_structure_type gets its parent's parent" do
    parent_structure_type = mock_model(
      StructureType,
      parent_structure_type: 'gramps')
    structure_type = build(
      :structure_type,
      name: 'This is my Name',
      parent_structure_type: parent_structure_type
    )
    expect(structure_type.grandparent_structure_type).to eq('gramps')
  end

  describe '#genus_structure_type' do
    let!(:parent_structure_type) do
      mock_model(StructureType, genus_structure_type?: true)
    end
    let!(:structure_type) do
      build(:structure_type,
            parent_structure_type: parent_structure_type,
            primary: true)
    end

    it 'is the structure_type itself if primary: false' do
      structure_type = build(:structure_type, primary: false)
      expect(structure_type.genus_structure_type).to eq(structure_type)
    end

    it 'is the parent if the parent is top level' do
      expect(structure_type.genus_structure_type).to eq(parent_structure_type)
    end

    it 'is the grandparent if the grandparent is top level' do
      gramps = mock_model(StructureType, genus_structure_type?: true)
      allow(parent_structure_type).to receive(:genus_structure_type?)
        .and_return(false)
      allow(parent_structure_type).to receive(:parent_structure_type)
        .and_return(gramps)
      expect(structure_type.genus_structure_type).to eq(gramps)
    end

    it 'is the structure type itself otherwise' do
      gramps = mock_model(StructureType, genus_structure_type?: false)
      allow(parent_structure_type).to receive(:genus_structure_type?)
        .and_return(false)
      allow(parent_structure_type).to receive(:parent_structure_type)
        .and_return(gramps)
      expect(structure_type.genus_structure_type).to eq(structure_type)
    end
  end

  describe '#has_physical_structure?' do
    it 'returns false if physical_structure_type is nil' do
      structure_type = described_class.new(physical_structure_type: nil)
      expect(structure_type.has_physical_structure?).to eq false
    end

    it 'returns true if physical_structure_type is not nil' do
      structure_type = described_class.new(physical_structure_type: 'Building')
      expect(structure_type.has_physical_structure?).to eq true
    end
  end

  describe '#physical_structure_class' do
    it 'returns nil if physical_structure_type is nil' do
      structure_type = described_class.new(physical_structure_type: nil)
      expect(structure_type.physical_structure_class).to eq nil
    end

    it 'returns a class if the physical_structure_type is a class' do
      structure_type = described_class.new(physical_structure_type: 'Building')
      expect(structure_type.physical_structure_class).to eq Building
    end
  end
  describe '#sampleable?' do
    it { expect(described_class.new(name: 'Apartment')).to be_sampleable }
    it { expect(described_class.new(name: 'Building')).to_not be_sampleable }
  end
end
