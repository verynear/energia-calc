require 'kilomeasure'

describe 'interior_lighting_and_controls' do
  include_examples 'measure', 'interior_lighting_and_controls'

  context 'sample 1' do
    let!(:before_inputs) do
      {
        quantity: 50,
        lamps_per_fixture: 2,
        lamp_type: 'Fluorescent',
        watts_per_lamp: 32,
        ballast_type: 'magnetic',
        controls: 'Manual Switch'
      }
    end

    let!(:after_inputs) do
      {
        quantity: 50,
        lamp_type: 'LED',
        controls: 'Bi-level occupancy',
        bilevel_fixture_low_power_wattage: 5,
        bilevel_fixture_high_power_wattage: 20,
        per_fixture_cost: 75,
        wattage: 22
      }
    end

    let!(:shared_inputs) do
      {
        electric_cost_per_kwh: 0.124,
        operating_hours_per_week: 168
      }
    end

    it { should_get_electric_savings(37_096.8) }
    it { should_get_cost_savings(37_096.8 * 0.124) }
    it { should_get_cost_of_measure(3750) }
  end

  context 'sample 2' do
    let!(:before_inputs) do
      {
        quantity: 14,
        lamps_per_fixture: 2,
        lamp_type: 'Fluorescent',
        watts_per_lamp: 27,
        ballast_type: 'electronic',
        controls: 'Manual Switch'
      }
    end

    let!(:after_inputs) do
      {
        quantity: 14,
        lamp_type: 'LED',
        controls: 'Manual Switch',
        per_fixture_cost: 50,
        wattage: 18
      }
    end

    let!(:shared_inputs) do
      {
        electric_cost_per_kwh: 0.124,
        operating_hours_per_week: 35,
        percentage_of_time_occupied: 20
      }
    end

    it { should_get_electric_savings(1160) }
    it { should_get_cost_savings(1160 * 0.124) }
    it { should_get_cost_of_measure(700) }
  end
end
