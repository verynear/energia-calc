require 'kilomeasure'

describe 'furnace replacement' do
  include_examples 'measure', 'furnace_replacement'

  let!(:before_inputs) do
    {
      afue: 0.7
    }
  end

  let!(:after_inputs) do
    {
      afue: 0.96,
      furnace_cost: 30_000
    }
  end

  let!(:shared_inputs) do
    {
      year_built: '< 1940',
      region: 'E N Central',
      average_unit_size: 900,
      num_units: 12,
      gas_cost_per_therm: 1
    }
  end

  it { should_get_gas_savings(1813.5) }
  it { should_get_cost_savings(1813.5) }
  it { should_get_cost_of_measure(30_000) }
  it { should_get_years_to_payback(16.5) }
end
