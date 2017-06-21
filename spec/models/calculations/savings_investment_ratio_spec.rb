require 'rails_helper'

describe Calculations::SavingsInvestmentRatio do
  it 'returns nil if required fields are missing' do
    calculator = instance_double(
      MeasureSelectionCalculator,
      annual_cost_savings: nil,
      cost_of_measure: 60_000,
      retrofit_lifetime: 20)

    sir = described_class.new(
      calculator: calculator
    ).call
    expect(sir).to eq(nil)
  end

  it 'returns :infinity if cost_of_measure is 0' do
    calculator = instance_double(
      MeasureSelectionCalculator,
      annual_cost_savings: 4_400,
      cost_of_measure: 0,
      retrofit_lifetime: 20)

    sir = described_class.new(
      calculator: calculator
    ).call
    expect(sir).to eq(:infinity)
  end

  it 'calculates an SIR' do
    audit_report =
      instance_double(
        FullAuditReport,
        escalation_rate: 4,
        inflation_rate: 2,
        interest_rate: 6)
    calculator = instance_double(
      MeasureSelectionCalculator,
      annual_maintenance_cost_savings: 300,
      annual_cost_savings: 4_400,
      cost_of_measure: 60_000,
      retrofit_lifetime: 20,
      degradation_rate: 1)

    sir = described_class.new(
      audit_report: audit_report,
      calculator: calculator
    ).call
    expect(sir).to eq(1.1664)
  end

  it 'calculates an SIR when percentages are missing' do
    audit_report =
      instance_double(
        FullAuditReport,
        escalation_rate: nil,
        inflation_rate: nil,
        interest_rate: nil)

    calculator = instance_double(
      MeasureSelectionCalculator,
      annual_maintenance_cost_savings: nil,
      annual_cost_savings: 7_500,
      cost_of_measure: 45_000,
      retrofit_lifetime: 20,
      degradation_rate: nil)

    sir = described_class.new(
      audit_report: audit_report,
      calculator: calculator
    ).call
    expect(sir).to eq(3.3333)
  end
end
