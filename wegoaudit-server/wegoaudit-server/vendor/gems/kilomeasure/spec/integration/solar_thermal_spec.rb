require 'kilomeasure'

describe 'solar thermal (input-only)' do
  include_examples 'measure', 'solar_thermal'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      solar_thermal_cost: 4_000,
      input_annual_gas_savings: 1_000,
      input_annual_electric_savings: 1_000
    }
  end

  let!(:shared_inputs) do
    {
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1
    }
  end

  it { should_get_gas_savings(1_000) }
  it { should_get_electric_savings(1_000) }

  it { should_get_cost_savings(2_000) }
  it { should_get_cost_of_measure(4_000) }
  it { should_get_years_to_payback(2) }
end
