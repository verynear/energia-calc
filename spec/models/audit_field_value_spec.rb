require 'rails_helper'

describe AuditFieldValue do
  it { should belong_to :audit_field }
  it { should belong_to :audit_structure }
  it { should validate_presence_of :audit_field_id }
  it { should validate_presence_of :audit_structure_id }

  it 'allows long values for string_value' do
    long_value = 'x' * 300
    audit_structure = create(:audit_structure)
    audit_field = create(:audit_field, :string)
    audit_field_value = audit_field.audit_field_values.create!(string_value: long_value,
                                             audit_structure: structure)
    expect(audit_field_value.string_value).to eq long_value
  end

  it 'should validate uniqueness of field_id scoped to structure' do
    audit_field = create(:audit_field)
    audit_structure = create(:audit_structure)
    params = { audit_structure_id: audit_structure.id, audit_field_id: audit_field.id }
    audit_field_value = create(:audit_field_value, params)

    expect{ create(:audit_field_value, params) }
      .to raise_error(ActiveRecord::RecordInvalid,
                      'Validation failed: Field has already been taken')
  end

  describe '#value' do
    it 'returns the value from the correct storage column' do
      audit_field = create(:audit_field, :text)
      audit_field_value = audit_field.audit_field_values.build(string_value: 'foo')
      expect(audit_field_value.value).to eq 'foo'
    end

    it 'converts date columns into an integer' do
      current_time = DateTime.current
      audit_field = create(:audit_field, :date)
      audit_field_value = audit_field.audit_field_values.build(date_value: current_time)
      expect(audit_field_value.value).to eq current_time
    end
  end

  describe '#value=' do
    it 'does nothing if nil is passed in' do
      audit_field_value = AuditFieldValue.new
      actual = audit_field_value.value = nil
      expect(actual).to eq nil
    end

    it 'sets the correct storage column' do
      audit_field = create(:audit_field, :text)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = 'foo'
      expect(audit_field_value.string_value).to eq 'foo'
    end

    it 'converts integers' do
      audit_field = create(:audit_field, :integer)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = 42
      expect(audit_field_value.integer_value).to eq 42
    end

    it 'converts floats' do
      audit_field = create(:audit_field, :float)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = '3.14'
      expect(audit_field_value.float_value).to eq 3.14
    end

    it 'converts decimals' do
      audit_field = create(:audit_field, :decimal)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = '3.14159265359'
      expect(audit_field_value.decimal_value).to eq BigDecimal.new('3.14159265359')
    end

    it 'converts dates' do
      current_time = DateTime.current
      audit_field = create(:audit_field, :date)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = current_time
      expect(audit_field_value.date_value).to eq current_time
    end

    it 'sets booleans' do
      audit_field = create(:audit_field, :switch)
      audit_field_value = audit_field.audit_field_values.build
      audit_field_value.value = true
      expect(audit_field_value.boolean_value).to eq true
    end
  end
end
