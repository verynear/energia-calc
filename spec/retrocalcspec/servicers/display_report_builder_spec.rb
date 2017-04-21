require 'rails_helper'

describe DisplayReportBuilder do
  let!(:field_value1) do
    instance_double(FieldValue, field_api_name: 'foo', value: 2)
  end
  let!(:field_value2) do
    instance_double(FieldValue, field_api_name: 'bar', value: '')
  end
  let(:audit_report) do
    instance_double(
      AuditReport,
      markdown: '**hello**',
      name: 'audit report',
      user: instance_double(User, name: 'Sad Panda', as_json: :json),
      field_values: [field_value1, field_value2]
    )
  end

  let(:audit_report_calculator) { instance_double(AuditReportCalculator) }

  it 'builds a display report' do
    builder = described_class.new(
      audit_report_calculator: audit_report_calculator,
      audit_report: audit_report
    )
    allow(DisplayReport).to receive(:new).and_return(:display_report)

    expect(builder.display_report).to eq(:display_report)
    expect(DisplayReport).to have_received(:new).with(
      registers: {
        audit_report_calculator: audit_report_calculator,
        for_pdf: false,
        mode: 'rendered',
        audit_report: audit_report
      },
      filename: 'audit report',
      markdown: '**hello**',
      locals: {
        'foo' => 2,
        'bar' => '<strong>[bar]</strong>',
        'user_name' => 'Sad Panda'
      }
    )
  end
end
