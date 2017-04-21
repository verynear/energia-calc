require 'rails_helper'

describe AuditReport do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:wegoaudit_id) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many(:apartment_monthly_data) }
  it { is_expected.to have_many(:building_monthly_data) }
  it { is_expected.to have_many(:measure_selections) }
  it { is_expected.to have_many(:measures) }
  it { is_expected.to have_many(:field_values) }

  specify '#data is a hash by default' do
    expect(described_class.new.data).to eq({})
  end

  specify '#audit is an instance of Audit' do
    expect(described_class.new.audit).to be_a(Wegoaudit::Audit)
  end

  specify '#audit_name uses name on data' do
    audit = described_class.new(data: { name: 'foo' })
    expect(audit.audit_name).to eq('foo')
  end
end
