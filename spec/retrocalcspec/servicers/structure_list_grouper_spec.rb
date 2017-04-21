require 'rails_helper'

describe StructureListGrouper do
  let!(:measure_selection) { create(:measure_selection) }
  let!(:structure_type) do
    create(:structure_type, name: 'Lighting', api_name: 'lighting')
  end
  let!(:structure_type_definition) do
    instance_double(
      StructureTypeDefinition,
      grouping_field_api_name: 'lamp_type')
  end

  before do
    allow(measure_selection).to receive(:structure_type_definition_for)
      .with(structure_type)
      .and_return(structure_type_definition)
  end

  describe '#grouped_structures' do
    it 'returns original structures if sample group ids not present' do
      json_structures = [
        { id: SecureRandom.uuid,
          name: 'Hallway lights',
          structure_type: { name: 'Lighting', api_name: 'lighting' },
          n_structures: 1,
          sample_group_id: nil,
          field_values: {
            lamp_type: {
              name: 'Lamp type',
              value: 'LED',
              value_type: 'string' }
          }
        },
        { id: SecureRandom.uuid,
          name: 'Kitchen lights',
          structure_type: { name: 'Lighting', api_name: 'lighting' },
          n_structures: 1,
          sample_group_id: nil,
          field_values: {
            lamp_type: {
              name: 'Lamp type',
              value: 'LED',
              value_type: 'string' }
          }
        }
      ]
      structures = json_structures.map do |json|
        Wegoaudit::Structure.new(json)
      end

      grouper = described_class.new(
        measure_selection, structure_type, structures)
      expect(grouper.grouped_structures).to eq structures
    end

    it 'returns original structures if sample group ids are different' do
      json_structures = [
        { id: SecureRandom.uuid,
          name: 'Hallway lights',
          structure_type: { name: 'Lighting', api_name: 'lighting' },
          n_structures: 4,
          sample_group_id: 'foo',
          field_values: {
            lamp_type: {
              name: 'Lamp type',
              value: 'LED',
              value_type: 'string' }
          }
        },
        { id: SecureRandom.uuid,
          name: 'Kitchen lights',
          structure_type: { name: 'Lighting', api_name: 'lighting' },
          n_structures: 2,
          sample_group_id: 'bar',
          field_values: {
            lamp_type: {
              name: 'Lamp type',
              value: 'LED',
              value_type: 'string' }
          }
        }
      ]
      structures = json_structures.map do |json|
        Wegoaudit::Structure.new(json)
      end

      grouper = described_class.new(
        measure_selection, structure_type, structures)
      expect(grouper.grouped_structures).to eq structures
    end

    it 'returns original structures if grouping field values are different' do
      json_structures = [
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
              value: 'type2',
              value_type: 'string' }
          }
        }
      ]
      structures = json_structures.map do |json|
        Wegoaudit::Structure.new(json)
      end

      grouper = described_class.new(
        measure_selection, structure_type, structures)
      expect(grouper.grouped_structures).to eq structures
    end

    it 'calls StructureCombiner if grouping field values are the same' do
      json_structures = [
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
      structures = json_structures.map do |json|
        Wegoaudit::Structure.new(json)
      end

      combiner = instance_double(StructureCombiner)
      expect(StructureCombiner).to receive(:new).with(structures)
        .and_return(combiner)
      expect(combiner).to receive(:combined_structures)

      grouper = described_class.new(
        measure_selection, structure_type, structures)
      grouper.grouped_structures
    end
  end
end
