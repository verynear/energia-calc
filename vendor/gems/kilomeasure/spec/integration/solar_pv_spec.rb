require 'kilomeasure'

describe 'Solar PV (input-only)' do
  include_examples 'measure', 'solar_pv'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      initial_cost: 5_000,
      potential_incentives: 1_000,
      annual_electric_output: 2_000,
      annual_solar_radiation: 10_000,
      energy_value: 4_000
    }
  end

  let!(:shared_inputs) do
    {
    }
  end

  it { should_get_electric_savings(2_000) }
  it { should_get_cost_savings(4_000) }
  it { should_get_cost_of_measure(4_000) }
  it { should_get_years_to_payback(1) }
end
