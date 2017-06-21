require 'rails_helper'

describe AuditStructureCreator do
  let!(:audit) { create(:audit) }
  let(:audit_audit_strc_type) { audit.audit_structure.audit_strc_type }

  it 'creates a structure record' do
    audit_strc_type = create(:audit_strc_type,
                            parent_structure_type: audit_audit_strc_type)
    creator = AuditStructureCreator.new(
      params: {
        name: 'My structure'
      },
      parent_structure: audit.audit_structure,
      audit_strc_type: audit_strc_type
    )
    creator.execute!

    audit_structure = creator.audit_structure
    expect(audit_structure).to be_persisted
    expect(audit_structure.name).to eq 'My structure'
    expect(audit_structure.parent_structure).to eq audit.audit_structure
    expect(audit_structure.audit_strc_type).to eq audit_strc_type
    expect(audit_structure.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(audit_structure.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end

  it 'creates a physical structure record when appropriate' do
    building_type = create(:building_audit_strc_type,
                           parent_structure_type: audit_audit_strc_type)
    creator = AuditStructureCreator.new(
      params: {
        name: 'My building',
      },
      parent_structure: audit.audit_structure,
      audit_strc_type: building_type
    )
    creator.execute!

    physical_structure = creator.audit_structure.physical_structure
    expect(physical_structure).to be_persisted
    expect(physical_structure).to be_a(Building)
    expect(physical_structure.name).to eq 'My building'
    expect(physical_structure.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(physical_structure.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end
end
