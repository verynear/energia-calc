require 'rails_helper'

describe SampleGroupCreator do
  let!(:audit) { create(:audit) }
  let(:audit_audit_strc_type) { audit.audit_structure.audit_strc_type }

  it 'creates a sample group record' do
    audit_strc_type = create(:common_area_audit_strc_type,
                            parent_structure_type: audit_audit_strc_type)
    creator = described_class.new(
      params: {
        n_structures: 10,
        name: 'My hallway'
      },
      parent_structure: audit.audit_structure,
      audit_strc_type: audit_strc_type
    )
    creator.execute!

    sample_group = creator.sample_group
    expect(sample_group).to be_persisted
    expect(sample_group.name).to eq 'My hallway'
    expect(sample_group.parent_structure).to eq audit.audit_structure
    expect(sample_group.audit_strc_type).to eq audit_strc_type
    expect(sample_group.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(sample_group.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end
end
