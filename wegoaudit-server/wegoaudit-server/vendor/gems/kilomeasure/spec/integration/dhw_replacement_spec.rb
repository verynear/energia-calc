require 'kilomeasure'

describe 'dhw replacement' do
  include_examples 'measure', 'dhw_replacement'

  let!(:before_inputs) do
    {
      afue: 0.7,
      tank_efficiency: 0.8
    }
  end

  let!(:after_inputs) do
    {
      afue: 0.92,
      tank_efficiency: 0.8,
      dhw_unit_cost: 9380
    }
  end

  let!(:shared_inputs) do
    {
      heating_fuel_baseload_in_therms: 2061.20,
      gas_cost_per_therm: 1
    }
  end

  it { should_get_gas_savings(492.8956522) }
  it { should_get_cost_savings(492.8956522) }
  it { should_get_cost_of_measure(9380) }
  it { should_get_years_to_payback(19.03) }
end
