require 'rails_helper'

describe StructureCreator do
  include WegoauditSupport

  let!(:field1) { create(:field) }
  let!(:field2) { create(:field) }
  let!(:structure_wegoaudit_id) { SecureRandom.uuid }

  let!(:structure_type) { create(:structure_type) }
  let!(:structure_change) do
    create(:structure_change,
           structure_wegoaudit_id: structure_wegoaudit_id,
           structure_type: structure_type)
  end
  let!(:measure_selection) do
    structure_change.measure_selection
  end
  let!(:measure) { measure_selection.measure }
  let!(:audit_report) do
    structure_change.measure_selection.audit_report
  end
  let!(:measure_definition) do
    instance_double(
      MeasureDefinition,
      inputs_only?: false,
      fields_for_structure_type: [field1, field2])
  end
  let!(:structure_type_definition) do
    instance_double(
      StructureTypeDefinition,
      proposed_only_field?: false,
      existing_only_field?: false)
  end

  before do
    allow(measure).to receive(:definition).and_return(measure_definition)
    allow(measure_definition).to receive(:structure_type_definition_for)
      .with(structure_type)
      .and_return(structure_type_definition)

    payload = audit_payload(
      'name' => 'report',
      'id' => 'uuid',
      'date' => '2015-05-15',
      'audit_type' => 'type',
      'structures' => [
        {
          'id' => structure_wegoaudit_id,
          'substructures' => [],
          'name' => 'Toaster',
          'field_values' => {
            field1.api_name => {
              'name' => field1.name,
              'value' => 1,
              'value_type' => field1.value_type
            }
          },
          'n_structures' => 3,
          'structure_type' => {
            'name' => structure_type.name,
            'api_name' => structure_type.api_name
          }
        }
      ],
      'measures' => [])

    audit_report.update!(data: payload['audit'])
  end

  it 'creates a structure with field values' do
    creator = described_class.new(
      measure: measure,
      structure_change: structure_change)

    structure = creator.create
    expect(structure.proposed).to eq(false)
    expect(structure.field_values.order(:id).map(&:field_api_name))
      .to eq([field1.api_name, field2.api_name])
    expect(structure.field_values.order(:id).map(&:value)).to eq(['1', nil])
  end

  it 'creates a proposed structure if flag is passed' do
    creator = described_class.new(
      measure: measure,
      structure_change: structure_change,
      proposed: true
    )

    structure = creator.create
    expect(structure.proposed).to eq(true)
  end

  it 'sets quantity based on n_structures' do
    creator = described_class.new(
      measure: measure,
      structure_change: structure_change)

    structure = creator.create
    expect(structure.quantity).to eq(3)
  end

  it 'skips a proposed_only field if structure is not proposed' do
    allow(structure_type_definition).to receive(:proposed_only_field?)
      .with(field1).and_return(true)
    creator = described_class.new(
      measure: measure,
      structure_change: structure_change)

    structure = creator.create
    expect(structure.field_values.order(:id).map(&:field_api_name))
      .to eq([field2.api_name])
  end

  it 'skips a existing_only field if structure is proposed' do
    allow(structure_type_definition).to receive(:existing_only_field?)
      .with(field1).and_return(true)
    creator = described_class.new(
      measure: measure,
      proposed: true,
      structure_change: structure_change)

    structure = creator.create
    expect(structure.field_values.order(:id).map(&:field_api_name))
      .to eq([field2.api_name])
  end
end
