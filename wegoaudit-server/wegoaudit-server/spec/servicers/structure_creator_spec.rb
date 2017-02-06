require 'rails_helper'

describe StructureCreator do
  let!(:audit) { create(:audit) }
  let(:audit_structure_type) { audit.structure.structure_type }

  it 'creates a structure record' do
    structure_type = create(:structure_type,
                            parent_structure_type: audit_structure_type)
    creator = StructureCreator.new(
      params: {
        name: 'My structure'
      },
      parent_structure: audit.structure,
      structure_type: structure_type
    )
    creator.execute!

    structure = creator.structure
    expect(structure).to be_persisted
    expect(structure.name).to eq 'My structure'
    expect(structure.parent_structure).to eq audit.structure
    expect(structure.structure_type).to eq structure_type
    expect(structure.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(structure.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end

  it 'creates a physical structure record when appropriate' do
    building_type = create(:building_structure_type,
                           parent_structure_type: audit_structure_type)
    creator = StructureCreator.new(
      params: {
        name: 'My building',
      },
      parent_structure: audit.structure,
      structure_type: building_type
    )
    creator.execute!

    physical_structure = creator.structure.physical_structure
    expect(physical_structure).to be_persisted
    expect(physical_structure).to be_a(Building)
    expect(physical_structure.name).to eq 'My building'
    expect(physical_structure.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(physical_structure.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end
end
