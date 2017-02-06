require 'rails_helper'

describe SampleGroupCreator do
  let!(:audit) { create(:audit) }
  let(:audit_structure_type) { audit.structure.structure_type }

  it 'creates a sample group record' do
    structure_type = create(:common_area_structure_type,
                            parent_structure_type: audit_structure_type)
    creator = described_class.new(
      params: {
        n_structures: 10,
        name: 'My hallway'
      },
      parent_structure: audit.structure,
      structure_type: structure_type
    )
    creator.execute!

    sample_group = creator.sample_group
    expect(sample_group).to be_persisted
    expect(sample_group.name).to eq 'My hallway'
    expect(sample_group.parent_structure).to eq audit.structure
    expect(sample_group.structure_type).to eq structure_type
    expect(sample_group.successful_upload_on).to be_a(ActiveSupport::TimeWithZone)
    expect(sample_group.upload_attempt_on).to be_a(ActiveSupport::TimeWithZone)
  end
end
