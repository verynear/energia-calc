require 'rails_helper'

describe SampleGroup do
  it { should belong_to(:structure_type) }
  it { should belong_to(:parent_structure).class_name('Structure') }
  it { should have_many(:substructures) }

  it { should allow_value(0).for(:n_structures) }
  it { should allow_value(1).for(:n_structures) }
  it { should_not allow_value('foo').for(:n_structures) }
  it { should_not allow_value(nil).for(:n_structures) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:parent_structure_id) }
  it { should validate_presence_of(:structure_type_id) }

  it '#audit returns nil because sample groups cannot belong to audits' do
    expect(SampleGroup.new.audit).to eq nil
  end

  it '#sample_groups returns an empty array' do
    expect(SampleGroup.new.sample_groups).to eq []
  end
end
