require 'kilomeasure'

describe 'showerheads' do
  include_examples 'measure', 'showerheads'

  let!(:before_inputs) do
    {
      afue: 0.7,
      gpm: 2.5,
      dhw_cold_water_temperature: 80,
      dhw_hot_water_temperature: 130
    }
  end

  let!(:after_inputs) do
    {
      gpm: 1.5,
      dhw_cold_water_temperature: 80,
      dhw_hot_water_temperature: 130,
      showerhead_cost: 360
    }
  end

  let!(:shared_inputs) do
    {
      # confirm that the num_occupants formula is used when input not provided
      num_occupants: nil,
      num_apartments: 10,
      num_bedrooms: 10,
      gas_cost_per_therm: 1,
      water_cost_per_gallon: 0.00844
    }
  end

  it { should_get_water_savings(43_840) }
  it { should_get_gas_savings(128.4) }
  it { should_get_cost_savings(498.4) }
  it { should_get_cost_of_measure(360) }
  it { should_get_years_to_payback(0.7) }
end
