require 'rails_helper'

describe SampleGroupCloneService do
  let(:audit) { create(:audit) }
  let(:common_area_type) { create(:audit_strc_type, name: 'Common Area') }
  let(:sample_group) do
    create(:sample_group,
           name: 'My sample group',
           parent_structure: audit.audit_structure,
           audit_strc_type: common_area_type)
  end

  it 'sets and gets params' do
    service = described_class.new(params: :foo)
    expect(service.params).to eq :foo
  end

  it 'sets and gets sample_group' do
    service = described_class.new(sample_group: :foo)
    expect(service.sample_group).to eq :foo
  end

  it 'clones the sample group' do
    service = described_class.new(
      params: { name: 'My cloned sample group' },
      sample_group: sample_group
    )
    service.execute!
    expect(audit.audit_structure.sample_groups.map(&:name)).to eq [
      'My sample group',
      'My cloned sample group'
    ]
  end


  it 'clones all sampled structures' do
    hallway = create(:audit_structure,
                     name: 'My hallway',
                     sample_group: sample_group,
                     audit_strc_type: common_area_type)
    service = described_class.new(
      params: { name: 'My cloned sample group' },
      sample_group: sample_group
    )
    service.execute!
    expect(service.cloned_sample_group.substructures.map(&:name)).to eq ['My hallway']
  end
end
