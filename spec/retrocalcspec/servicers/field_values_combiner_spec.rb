require 'rails_helper'

describe FieldValuesCombiner do
  let!(:structure1) do
    {
      field_values: {
        wattage: {
          name: 'Wattage',
          value: '60.0',
          value_type: 'decimal'
        },
        run_hours: {
          name: 'Run hours',
          value: '18',
          value_type: 'integer'
        },
        ballast_type: {
          name: 'Ballast type',
          value: 'type A',
          value_type: 'picker'
        }
      }
    }
  end
  let!(:structure2) do
    {
      field_values: {
        wattage: {
          name: 'Wattage',
          value: '50.0',
          value_type: 'decimal'
        },
        run_hours: {
          name: 'Run hours',
          value: '12',
          value_type: 'integer'
        },
        ballast_type: {
          name: 'Ballast type',
          value: 'type A',
          value_type: 'picker'
        }
      }
    }
  end
  let!(:structure3) do
    {
      field_values: {
        wattage: {
          name: 'Wattage',
          value: '40.0',
          value_type: 'decimal'
        },
        ballast_type: {
          name: 'Ballast type',
          value: 'type A',
          value_type: 'picker'
        }
      }
    }
  end
  let!(:json_structures) { [structure1, structure2, structure3] }
  let!(:structures) do
    json_structures.map { |json| Wegoaudit::Structure.new(json) }
  end
  let!(:structure_field_values) { structures.map(&:field_values) }
  let!(:combiner) { described_class.new(structure_field_values) }

  describe '#combined_field_values' do
    it 'returns a hash with all keys from underlying field values' do
      composite_field_values = combiner.combined_field_values
      expect(composite_field_values.keys)
        .to match_array %w[wattage run_hours ballast_type]
    end

    it 'averages field values of type integer or decimal' do
      composite_field_values = combiner.combined_field_values

      expect(composite_field_values['wattage']['value']).to eq 50.0
      expect(composite_field_values['run_hours']['value']).to eq 15
    end

    it 'takes the first value if type is not integer or decimal' do
      composite_field_values = combiner.combined_field_values
      expect(composite_field_values['ballast_type']['value']).to eq 'type A'
    end
  end
end
