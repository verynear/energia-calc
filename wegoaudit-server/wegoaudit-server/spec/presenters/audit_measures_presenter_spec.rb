require 'rails_helper'

describe AuditMeasuresPresenter do
  it 'assigns the audit instance' do
    audit = instance_double(Audit)
    expect(described_class.new(audit).audit).to eq audit
  end

  it 'returns an array of all active measures' do
    audit = create(:audit)
    measure1 = create(:measure,
                      active: true,
                      name: 'Measure 1')
    measure2 = create(:measure,
                      active: false,
                      name: 'Measure 2')
    presenter = described_class.new(audit)
    expect(presenter.measures.map(&:name)).to eq ['Measure 1']
  end

  it 'maps measure_values onto their corresponding measures' do
    audit = create(:audit)
    measure1 = create(:measure, name: 'Measure 1')
    measure2 = create(:measure, name: 'Measure 2')
    measure_value = create(:measure_value,
                           audit: audit,
                           measure: measure1,
                           value: true,
                           notes: 'My important note')
    presenter = described_class.new(audit)
    expect(presenter.measures.map(&:value)).to eq [true, nil]
    expect(presenter.measures.map(&:notes)).to eq ['My important note', nil]
  end
end
