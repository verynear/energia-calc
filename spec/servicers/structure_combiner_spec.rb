require 'rails_helper'

describe StructureCombiner do
  before do
    create(:structure_type, name: 'Lighting', api_name: 'lighting')
  end

  let!(:json_structures) do
    [
      { id: SecureRandom.uuid,
        name: 'Hallway lights',
        structure_type: { name: 'Lighting', api_name: 'lighting' },
        n_structures: 4,
        sample_group_id: 'foo',
        field_values: {
          lamp_type: {
            name: 'Lamp type',
            value: 'type1',
            value_type: 'string' }
        }
      },
      { id: SecureRandom.uuid,
        name: 'Kitchen lights',
        structure_type: { name: 'Lighting', api_name: 'lighting' },
        n_structures: 2,
        sample_group_id: 'foo',
        field_values: {
          lamp_type: {
            name: 'Lamp type',
            value: 'type1',
            value_type: 'string' }
        }
      }
    ]
  end
  let!(:structures) do
    json_structures.map { |json| Wegoaudit::Structure.new(json) }
  end
  let!(:combiner) { described_class.new(structures) }

  describe '#combined_structures' do
    it 'returns a structure' do
      structure = combiner.combined_structures
      expect(structure.class).to eq(Wegoaudit::Structure)
    end

    it 'sums n_structures across the provided structures' do
      structure = combiner.combined_structures
      expect(structure.n_structures).to eq 6
    end

    it 'calls FieldValuesCombiner with field_values for each structure' do
      field_values = {
        lamp_type: {
          name: 'Lamp type',
          value: 'type1',
          value_type: 'string'
        }
      }
      structure_field_values = [field_values, field_values]

      field_values_combiner = instance_double(FieldValuesCombiner)
      expect(FieldValuesCombiner).to receive(:new).with(structure_field_values)
        .and_return(field_values_combiner)
      expect(field_values_combiner).to receive(:combined_field_values)

      combiner.combined_structures
    end
  end
end
