require 'rails_helper'

describe AuditReportCreator do
  def audit_payload(data)
    payload = { 'audit' => data }
    expect(payload).to match_response_schema('retrocalc/audit')
    payload
  end

  describe '#create' do
    let(:audit_report) { instance_double(AuditReport, id: 1) }
    let(:user) { create(:user) }

    it 'creates an audit report' do
      payload = audit_payload(
        'name' => 'report',
        'id' => 'uuid',
        'date' => 'date',
        'audit_type' => 'type',
        'temp_structures' => [],
        'measures' => [])

      creator = described_class.new(
        data: payload['audit'],
        report_template: 'report_template',
        user: user,
        wegoaudit_id: 'uuid')
      allow(AuditReport).to receive(:create!)
        .with(name: 'report',
              report_template: 'report_template',
              user_id: user.id,
              organization_id: user.organization_id,
              data: payload['audit'],
              wegoaudit_id: 'uuid')
        .and_return(audit_report)
      expect(creator.create).to eq(audit_report)
    end

    it 'associates measures with audit report' do
      measure1 = instance_double(Measure)
      measure2 = instance_double(Measure)

      payload = audit_payload(
        'id' => 'uuid',
        'name' => 'report',
        'date' =>  'today',
        'audit_type' => 'something',
        'measures' => [
          { 'name' => 'measure1',
            'api_name' => 'measure_id1',
            'notes' => nil
          },
          { 'name' => 'measure2',
            'api_name' => 'measure_id2',
            'notes' => 'some notes'
          }],
        'structures' => [])

      creator = described_class.new(
        data: payload['audit'],
        report_template: 'report_template',
        user: user,
        wegoaudit_id: 'uuid')
      allow(AuditReport).to receive(:create!)
        .with(name: 'report',
              user_id: user.id,
              organization_id: user.organization_id,
              data: payload['audit'],
              report_template: 'report_template',
              wegoaudit_id: 'uuid')
        .and_return(audit_report)

      measure_selection_creator1 = instance_double(MeasureSelectionCreator)
      measure_selection_creator2 = instance_double(MeasureSelectionCreator)

      allow(Measure).to receive(:by_api_name!).with('measure_id1')
        .and_return(measure1)
      allow(Measure).to receive(:by_api_name!).with('measure_id2')
        .and_return(measure2)
      allow(MeasureSelectionCreator).to receive(:new)
        .with(audit_report: audit_report, measure: measure1, notes: nil)
        .and_return(measure_selection_creator1)
      allow(MeasureSelectionCreator).to receive(:new).with(
        audit_report: audit_report, measure: measure2, notes: 'some notes')
        .and_return(measure_selection_creator2)

      expect(measure_selection_creator1).to receive(:create)
      expect(measure_selection_creator2).to receive(:create)
      expect(creator.create).to eq(audit_report)
    end

    it 'imports wegowise data for buildings and apartments' do
      structures = [
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'field_values' => {},
          'n_structures' => 1,
          'substructures' => []
        }
      ]

      payload = audit_payload(
        'name' => 'report',
        'id' => 'uuid',
        'date' => 'date',
        'audit_type' => 'type',
        'structures' => structures,
        'measures' => [])

      creator = described_class.new(
        data: payload['audit'],
        user: user,
        wegoaudit_id: 'uuid')
      allow(AuditReport).to receive(:create!).and_return(audit_report)

      wegowise_ids = {
        'building' => { ids: [123] },
        'apartment' => { ids: [456, 789] },
        'meter' => { ids: [] }
      }
      finder = instance_double(WegowiseIdFinder)

      expect(WegowiseIdFinder).to receive(:new).with(structures)
        .and_return(finder)
      expect(finder).to receive(:find_ids).and_return(wegowise_ids)

      expect(MonthlyDataImportWorker).to receive(:perform_async)
        .with(user.id, 123, 'Building', 1)
      expect(MonthlyDataImportWorker).to receive(:perform_async)
        .with(user.id, 456, 'Apartment', 1)
      expect(MonthlyDataImportWorker).to receive(:perform_async)
        .with(user.id, 789, 'Apartment', 1)

      creator.create
    end
  end
end
