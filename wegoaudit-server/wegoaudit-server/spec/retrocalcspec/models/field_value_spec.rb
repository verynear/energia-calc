require 'rails_helper'

describe FieldValue do
  let(:field_api_name) { 'field' }
  let!(:field) do
    create(:field, api_name: field_api_name)
    Field.by_api_name!(field_api_name)
  end
  let!(:field_value) { described_class.new(field_api_name: field.api_name) }

  it { is_expected.to belong_to(:parent) }

  specify '#field is set' do
    expect(field_value.field).to eq(field)
  end

  describe '#value' do
    it 'is an empty string that is treated as nil by default' do
      field.value_type = 'string'
      expect(field_value[:value]).to eq('')
      expect(field_value.value).to eq(nil)
    end

    specify 'with string value_type it casts to a string' do
      field_value.value = '123'
      field.value_type = 'string'
      expect(field_value.value).to eq('123')
    end

    specify 'with picker value_type it casts to a string' do
      field_value.value = '123'
      field.value_type = 'picker'
      expect(field_value.value).to eq('123')
    end

    specify 'with decimal value_type it casts to a BigDecimal' do
      field_value.value = '0.123'
      field.value_type = 'decimal'
      expect(field_value.value).to eq(BigDecimal.new('0.123'))
    end

    specify 'with integer value_type it casts to an integer' do
      field_value.value = '123'
      field.value_type = 'integer'
      expect(field_value.value).to eq(123)
    end

    specify 'with date value_type it casts to a datetime' do
      field_value.value = '2015-05-05 12:01'
      field.value_type = 'date'
      expect(field_value.value).to eq('2015-05-05 12:01'.to_datetime)
    end

    specify 'with switch value_type it passes the value on' do
      field_value.value = 'true'
      field.value_type = 'switch'
      expect(field_value.value).to eq(true)
    end
  end

  specify '#from_audit asks wegoaudit_structure about structure' do
    wegoaudit_structure = instance_double(Wegoaudit::Structure)
    structure = mock_model(
      Structure,
      wegoaudit_structure: wegoaudit_structure)
    field_value.parent = structure
    allow(wegoaudit_structure).to receive(:has_field?)
      .with(field_api_name).and_return('something')

    expect(field_value.from_audit).to eq('something')
  end

  specify '#original_value asks wegoaudit_structure about value' do
    wegoaudit_structure = instance_double(
      Wegoaudit::Structure,
      field_values: { field_api_name => 'value' }
    )
    structure = mock_model(
      Structure,
      wegoaudit_structure: wegoaudit_structure)
    field_value.parent = structure

    expect(field_value.original_value).to eq('value')
  end
end
