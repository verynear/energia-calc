require 'kilomeasure'

describe 'duct_insulation' do
  include_examples 'measure', 'duct_insulation'

  let!(:before_inputs) do
    {
      length_of_duct: 50,
      perimeter_of_duct_cross_section: 5,
      temperature_inside_duct: 100,
      temperature_outside_duct: 50,
      thickness_of_duct_material: 0.25,
      conductivity_of_duct_material: 1,
      duct_insulation_cost: 650,
      gas_cost_per_therm: 1
    }
  end

  let!(:after_inputs) do
    before_inputs.merge(r_value_of_insulation: 8)
  end

  it { should_get_gas_savings(218) }
  it { should_get_cost_savings(218) }
  it { should_get_cost_of_measure(650) }
  it { should_get_years_to_payback(3) }
end
