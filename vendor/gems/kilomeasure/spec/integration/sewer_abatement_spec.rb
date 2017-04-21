require 'kilomeasure'

describe 'install sewer abatement meter (input-only)' do
  include_examples 'measure', 'sewer_abatement'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      meter_cost: 500,
      abatement_system: 'irrigation',
      annual_water_usage_through_meter: 1000,
      sewer_rate_per_gallon: 1
    }
  end

  let!(:shared_inputs) do
    {
    }
  end

  it { should_get_water_savings(1_000) }
  it { should_get_cost_savings(1_000) }
  it { should_get_cost_of_measure(500) }
  it { should_get_years_to_payback(0.5) }
end
