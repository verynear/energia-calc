require 'rails_helper'

describe SampleGroupDestroyer do
  let!(:audit) { create(:audit) }
  let!(:apartment_type) { create(:apartment_structure_type) }
  let!(:sample_group) do
    create(:sample_group,
           n_structures: 10,
           parent_structure: audit.structure,
           structure_type: apartment_type)
  end
  let(:destroyer) { described_class.new(sample_group: sample_group) }

  it 'destroys the sample group' do
    expect { destroyer.execute }
      .to change { SampleGroup.count }
      .from(1)
      .to(0)
  end

  it 'destroys associated structures' do
    create(:structure,
           sample_group: sample_group,
           structure_type: apartment_type)
    expect { destroyer.execute }
      .to change { Structure.count }
      .by(-1)
  end
end
