require 'rails_helper'

describe StructureFieldPresenter do
  let(:structure) { instance_double(Structure) }

  describe '#partial' do
    it 'returns the corresponding partial name for field types' do
      field = instance_double(Field, value_type: 'switch')
      presenter = described_class.new(structure, field)
      expect(presenter.partial).to eq 'checkbox_field'
    end

    it 'returns text_input for unknown field types' do
      field = instance_double(Field, value_type: 'spam')
      presenter = described_class.new(structure, field)
      expect(presenter.partial).to eq 'text_input_field'
    end
  end

  describe '#value' do
    let(:field) { instance_double(Field) }

    it 'returns nil if field_value is not nil' do
      presenter = described_class.new(structure, field)
      expect(presenter.value).to eq nil
    end

    it 'returns the field_value if it has one' do
      field_value = instance_double(FieldValue, value: :foo)
      presenter = described_class.new(structure, field, field_value)
      expect(presenter.value).to eq :foo
    end
  end
end
