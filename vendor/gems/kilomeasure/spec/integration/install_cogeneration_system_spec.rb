require 'kilomeasure'

describe 'install cogeneration system (input-only)' do
  include_examples 'measure', 'install_cogeneration_system'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      implementation_cost: 4_000,
      annual_maintenance_cost: 500,
      input_annual_gas_savings: 1_000,
      input_annual_electric_savings: 2_000,
      input_annual_oil_savings: 3_000
    }
  end

  let!(:shared_inputs) do
    {
      retrofit_lifetime: 10,
      gas_cost_per_therm: 1,
      electric_cost_per_kwh: 1,
      oil_cost_per_btu: 1
    }
  end

  it { should_get_gas_savings(1_000) }
  it { should_get_electric_savings(2_000) }
  it { should_get_oil_savings(3_000) }

  it { should_get_cost_savings(6_000) }
  it { should_get_cost_of_measure(9_000) }
  it { should_get_years_to_payback(1.5) }
end
