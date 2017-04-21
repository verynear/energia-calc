require 'kilomeasure'

describe 'refrigerator replacement' do
  include_examples 'measure', 'refrigerator_replacement'

  let!(:before_inputs) do
    {
      refrigerator_size_in_cf: 18,
      manufactured_year: '1976 - 86'
    }
  end

  let!(:after_inputs) do
    {
      refrigerator_size_in_cf: 18,
      energy_star_tier_of_refrigerator: 'CEE Tier 3',
      refrigerator_unit_cost: 510
    }
  end

  let!(:shared_inputs) do
    {
      electric_cost_per_kwh: 0.1
    }
  end

  it { should_get_electric_savings(94_950.0 / 90) }
  it { should_get_cost_savings(9_495.0 / 90) }
  it { should_get_cost_of_measure(510) }
  it { should_get_years_to_payback(4.8) }
end
