require 'kilomeasure'

describe 'duct air sealing (input-only)' do
  include_examples 'measure', 'duct_air_sealing'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      duct_cost: 4_000,
      leakage: 'No observable leaks',
      annual_heating_savings: 1_500,
      annual_cooling_savings: 500
    }
  end

  let!(:shared_inputs) do
    {
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1
    }
  end

  it { should_get_gas_savings(1_500) }
  it { should_get_electric_savings(500) }

  it { should_get_cost_savings(2_000) }
  it { should_get_cost_of_measure(4_000) }
  it { should_get_years_to_payback(2) }
end
