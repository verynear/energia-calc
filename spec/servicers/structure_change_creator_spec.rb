require 'rails_helper'

describe StructureChangeCreator do
  def audit_payload(data)
    payload = { 'audit' => data }
    expect(payload).to match_response_schema('retrocalc/audit')
    payload
  end

  let!(:measure_selection) { create(:measure_selection) }
  let!(:measure) { measure_selection.measure }
  let!(:audit_report) do
    measure_selection.audit_report
  end
  let!(:structure_wegoaudit_id) { SecureRandom.uuid }
  let!(:genus_structure_type) do
    mock_model(StructureType)
  end
  let!(:structure_type) do
    mock_model(StructureType, genus_structure_type: genus_structure_type)
  end

  before do
    payload = audit_payload(
      'name' => 'report',
      'id' => 'uuid',
      'date' => '2015-05-15',
      'audit_type' => 'type',
      'structures' => [],
      'measures' => [])
    audit_report.update!(data: payload['audit'])
  end

  it 'creates a structure_change with field values' do
    creator = described_class.new(
      measure: measure,
      measure_selection: measure_selection,
      structure_type: structure_type,
      structure_wegoaudit_id: structure_wegoaudit_id
    )
    allow(StructureCreator).to receive(:new)
      .with(structure_change: an_instance_of(StructureChange),
            measure: measure,
            proposed: anything)
      .and_return(instance_double(StructureCreator, create: nil))

    allow(StructureType).to receive(:find_by!).with(api_name: 'led')
      .and_return(structure_type)

    structure_change = creator.create

    expect(StructureCreator).to have_received(:new)
      .with(measure: measure,
            structure_change: structure_change,
            proposed: false)
    expect(StructureCreator).to have_received(:new)
      .with(measure: measure,
            structure_change: structure_change,
            proposed: true)
  end
end
