require 'rails_helper'

describe SampleGroupDestroyer do
  let!(:audit) { create(:audit) }
  let!(:apartment_type) { create(:apartment_audit_strc_type) }
  let!(:sample_group) do
    create(:sample_group,
           n_structures: 10,
           parent_structure: audit.audit_structure,
           audit_strc_type: apartment_type)
  end
  let(:destroyer) { described_class.new(sample_group: sample_group) }

  it 'destroys the sample group' do
    expect { destroyer.execute }
      .to change { SampleGroup.count }
      .from(1)
      .to(0)
  end

  it 'destroys associated structures' do
    create(:audit_structure,
           sample_group: sample_group,
           audit_strc_type: apartment_type)
    expect { destroyer.execute }
      .to change { AuditStructure.count }
      .by(-1)
  end
end
