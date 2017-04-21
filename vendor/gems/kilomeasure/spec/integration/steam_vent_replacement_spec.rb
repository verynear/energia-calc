require 'kilomeasure'

describe 'steam vent replacement (input-only)' do
  include_examples 'measure', 'steam_vent_replacement'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      vent_cost: 2_000,
      input_annual_gas_savings: 1_000
    }
  end

  let!(:shared_inputs) do
    {
      gas_cost_per_therm: 1
    }
  end

  it { should_get_gas_savings(1_000) }
  it { should_get_cost_savings(1_000) }
  it { should_get_cost_of_measure(2_000) }
  it { should_get_years_to_payback(2) }
end
