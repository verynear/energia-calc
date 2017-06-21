require 'rails_helper'

describe AuditMeasuresPresenter do
  it 'assigns the audit instance' do
    audit = instance_double(Audit)
    expect(described_class.new(audit).audit).to eq audit
  end

  it 'returns an array of all active measures' do
    audit = create(:audit)
    measure1 = create(:audit_measure,
                      active: true,
                      name: 'Measure 1')
    measure2 = create(:audit_measure,
                      active: false,
                      name: 'Measure 2')
    presenter = described_class.new(audit)
    expect(presenter.audit_measures.map(&:name)).to eq ['Measure 1']
  end

  it 'maps measure_values onto their corresponding measures' do
    audit = create(:audit)
    measure1 = create(:audit_measure, name: 'Measure 1')
    measure2 = create(:audit_measure, name: 'Measure 2')
    audit_measure_value = create(:audit_measure_value,
                           audit: audit,
                           audit_measure: measure1,
                           value: true,
                           notes: 'My important note')
    presenter = described_class.new(audit)
    expect(presenter.audit_measures.map(&:value)).to eq [true, nil]
    expect(presenter.audit_measures.map(&:notes)).to eq ['My important note', nil]
  end
end
