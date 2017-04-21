require 'rails_helper'

describe FieldValue do
  it { should belong_to :field }
  it { should belong_to :structure }
  it { should validate_presence_of :field_id }
  it { should validate_presence_of :structure_id }

  it 'allows long values for string_value' do
    long_value = 'x' * 300
    structure = create(:structure)
    field = create(:field, :string)
    field_value = field.field_values.create!(string_value: long_value,
                                             structure: structure)
    expect(field_value.string_value).to eq long_value
  end

  it 'should validate uniqueness of field_id scoped to structure' do
    field = create(:field)
    structure = create(:structure)
    params = { structure_id: structure.id, field_id: field.id }
    field_value = create(:field_value, params)

    expect{ create(:field_value, params) }
      .to raise_error(ActiveRecord::RecordInvalid,
                      'Validation failed: Field has already been taken')
  end

  describe '#value' do
    it 'returns the value from the correct storage column' do
      field = create(:field, :text)
      field_value = field.field_values.build(string_value: 'foo')
      expect(field_value.value).to eq 'foo'
    end

    it 'converts date columns into an integer' do
      current_time = DateTime.current
      field = create(:field, :date)
      field_value = field.field_values.build(date_value: current_time)
      expect(field_value.value).to eq current_time
    end
  end

  describe '#value=' do
    it 'does nothing if nil is passed in' do
      field_value = FieldValue.new
      actual = field_value.value = nil
      expect(actual).to eq nil
    end

    it 'sets the correct storage column' do
      field = create(:field, :text)
      field_value = field.field_values.build
      field_value.value = 'foo'
      expect(field_value.string_value).to eq 'foo'
    end

    it 'converts integers' do
      field = create(:field, :integer)
      field_value = field.field_values.build
      field_value.value = 42
      expect(field_value.integer_value).to eq 42
    end

    it 'converts floats' do
      field = create(:field, :float)
      field_value = field.field_values.build
      field_value.value = '3.14'
      expect(field_value.float_value).to eq 3.14
    end

    it 'converts decimals' do
      field = create(:field, :decimal)
      field_value = field.field_values.build
      field_value.value = '3.14159265359'
      expect(field_value.decimal_value).to eq BigDecimal.new('3.14159265359')
    end

    it 'converts dates' do
      current_time = DateTime.current
      field = create(:field, :date)
      field_value = field.field_values.build
      field_value.value = current_time
      expect(field_value.date_value).to eq current_time
    end

    it 'sets booleans' do
      field = create(:field, :switch)
      field_value = field.field_values.build
      field_value.value = true
      expect(field_value.boolean_value).to eq true
    end
  end
end
