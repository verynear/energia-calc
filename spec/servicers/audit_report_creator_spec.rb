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
