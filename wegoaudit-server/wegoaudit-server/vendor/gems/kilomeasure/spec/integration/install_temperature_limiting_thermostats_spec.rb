require 'kilomeasure'

describe 'install temperature limiting thermostats' do
  include_examples 'measure', 'install_temperature_limiting_thermostats'

  let!(:before_inputs) do
    {
    }
  end

  let!(:after_inputs) do
    {
      temperature_limit: 72,
      per_unit_cost: 1
    }
  end

  let!(:shared_inputs) do
    {
      energy_source: 'gas',
      heating_degree_days: 5_800,
      building_sqft: 50_000,
      heating_usage_in_therms: 23_205.5,
      gas_cost_per_therm: 1,
      average_indoor_temperature: 75,
      average_outdoor_temperature: 40.0484544
    }
  end

  it { should_get_gas_savings(1991.8) }
end
