require 'rails_helper'

describe AuditField do
  it { should belong_to :grouping }
  it { should have_many :audit_field_values }
  it { should validate_presence_of :name }
  it { should validate_presence_of :value_type }
  it { should validate_presence_of :display_order }

  it 'sets its api_name based on name' do
    audit_field = create(:audit_field, name: 'This is my Name')
    expect(audit_field.api_name).to eq('this_is_my_name')
  end

  it 'does not allow changing api_name' do
    audit_field = create(:audit_field, name: 'This is my Name')
    audit_field.api_name = 'foo'
    expect(audit_field).to_not be_valid
    expect(audit_field.errors[:api_name]).to eq(["Can't change api_name"])
  end

  it 'should validate uniqueness of display_order scoped to grouping' do
    create(:audit_field, value_type: 'string', grouping: create(:grouping))
    should validate_uniqueness_of(:display_order).scoped_to(:grouping_id)
  end
end
