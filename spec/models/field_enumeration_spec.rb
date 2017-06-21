require 'rails_helper'

describe FieldEnumeration do
  it { should belong_to :audit_field }
  it { should validate_presence_of :value }
  it { should validate_presence_of :display_order }

  it 'should validate uniques of display_order scoped to field_id' do
    audit_field = create(:audit_field)
    params = { display_order: 1, value: 'foo', audit_field: audit_field }
    create(:field_enumeration, params)
    expect{ create(:field_enumeration, params) }
      .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Display
        order has already been taken'.squish)
  end

end
