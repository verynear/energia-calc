require 'rails_helper'

describe StructureTypeDefinition do
  let!(:definition) do
    {
      field_for_grouping: 'blah',
      fields: {
        field1: {
          proposed_only: true,
          existing_only: false
        }
      }
    }
  end
  let!(:field) { instance_double(Field, api_name: 'field1') }

  let!(:structure_type_definition) do
    described_class.new(
      definition: definition,
      structure_type: instance_double(StructureType)
    )
  end

  specify do
    expect(structure_type_definition.grouping_field_api_name).to eq(:blah)
  end

  specify do
    expect(structure_type_definition.proposed_only_field?(field)).to eq(true)
  end

  specify do
    expect(structure_type_definition.existing_only_field?(field)).to eq(false)
  end
end
