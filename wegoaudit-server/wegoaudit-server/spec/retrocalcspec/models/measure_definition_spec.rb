require 'rails_helper'

describe MeasureDefinition do
  let!(:data) do
    {
      inputs: {
        measure: [:field2],
        structure_type1: [:field1],
        structure_type2: [:field1]
      },
      structures: {
        structure_type1: {
          field_for_grouping: :field1
        }
      }
    }
  end
  let!(:genus_structure_type) do
    instance_double(
      StructureType,
      genus_api_name: 'genus_structure_type')
  end
  let!(:structure_type1) do
    instance_double(
      StructureType,
      api_name: 'structure_type1',
      genus_api_name: 'genus_structure_type',
      genus_structure_type: genus_structure_type)
  end
  let!(:structure_type2) do
    instance_double(
      StructureType,
      api_name: 'structure_type2',
      genus_api_name: 'structure_type2')
  end
  let!(:kilomeasure_measure) do
    instance_double(Kilomeasure::Measure)
  end

  let(:definition) do
    described_class.new(
      name: 'api_name',
      local_definition: data,
      kilomeasure_measure: kilomeasure_measure
    )
  end

  before do
    allow(structure_type2).to receive(:genus_structure_type)
      .and_return(structure_type2)
    allow(StructureType).to receive(:by_api_name!)
      .with(:structure_type1)
      .and_return(structure_type1)
    allow(StructureType).to receive(:by_api_name!)
      .with(:structure_type2)
      .and_return(structure_type2)
    allow(Field).to receive(:by_api_name!).with(:utility_rebate)
      .and_return(:utility_rebate)
    allow(Field).to receive(:by_api_name!).with(:retrofit_lifetime)
      .and_return(:retrofit_lifetime)
    allow(Field).to receive(:by_api_name!).with(:field2).and_return(:field2)
    allow(Field).to receive(:by_api_name!).with(:field1).and_return(:field1)
  end

  describe '#structure_types' do
    it 'loads structure types directly' do
      expect(definition.structure_types)
        .to eq([structure_type1, structure_type2])
    end
  end

  specify '#measure_fields returns fields' do
    expect(definition.measure_fields)
      .to eq([:field2, :utility_rebate, :retrofit_lifetime])
  end

  describe '#fields_for_structure_type' do
    it 'returns an empty array if measure does not have structure type' do
      structure_type = instance_double(
        StructureType,
        genus_api_name: 'notpresent',
        api_name: 'notpresent')
      expect(definition.fields_for_structure_type(structure_type)).to eq([])
    end

    it 'loads fields from definition' do
      allow(Field).to receive(:by_api_name!).with(:field1).and_return(:field1)

      expect(definition.fields_for_structure_type(structure_type1))
        .to eq([:field1])
    end
  end
end
