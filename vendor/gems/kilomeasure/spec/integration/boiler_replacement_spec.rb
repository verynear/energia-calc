require 'kilomeasure'

describe 'boiler replacement' do
  include_examples 'measure', 'boiler_replacement'

  context 'with steam as working fluid' do
    let!(:before_inputs) do
      {
        boiler_input_btu_per_hour: 2_860_000,
        afue: 0.7,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 450
      }
    end

    let!(:after_inputs) do
      {
        boiler_input_btu_per_hour: 2_860_000,
        afue: 0.82,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 450
      }
    end

    let!(:shared_inputs) do
      {
        working_fluid: 'steam',
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'mild steel',
        heating_usage_in_therms: 28_261,
        boiler_cost: 36_270,
        gas_cost_per_therm: 1
      }
    end

    it { should_get_gas_savings(4146.1) }
    it { should_get_cost_savings(4146.1) }
    it { should_get_cost_of_measure(36_270) }
    it { should_get_years_to_payback(8.7) }
  end

  context 'with water as working fluid' do
    let!(:before_inputs) do
      {
        boiler_input_btu_per_hour: 300_000,
        afue: 0.68,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 150
      }
    end

    let!(:after_inputs) do
      {
        boiler_input_btu_per_hour: 300_000,
        afue: 0.92,
        length_uninsulated_pipe: 0,
        length_insulated_pipe: 150
      }
    end

    let!(:shared_inputs) do
      {
        working_fluid: 'water',
        outer_pipe_diameter_in_inches: 1.9,
        pipe_material: 'cast iron',
        heating_usage_in_therms: 6_036,
        boiler_cost: 30_000,
        gas_cost_per_therm: 1
      }
    end

    it { should_get_gas_savings(1_583.1) }
    it { should_get_cost_savings(1_583.1) }
    it { should_get_cost_of_measure(30_000) }
    it { should_get_years_to_payback(19.0) }
  end
end
