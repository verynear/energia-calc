require 'rails_helper'

describe FieldEnumeration do
  it { should belong_to :field }
  it { should validate_presence_of :value }
  it { should validate_presence_of :display_order }

  it 'should validate uniques of display_order scoped to field_id' do
    field = create(:field)
    params = { display_order: 1, value: 'foo', field: field }
    create(:field_enumeration, params)
    expect{ create(:field_enumeration, params) }
      .to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Display
        order has already been taken'.squish)
  end

end
