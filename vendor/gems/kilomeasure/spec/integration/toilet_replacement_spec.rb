require 'kilomeasure'

describe 'toilet_replacement' do
  include_examples 'measure', 'toilet_replacement'

  context 'without leakage, using existing and proposed defaults' do
    let!(:before_inputs) do
      {
        num_occupants: 20,
        num_bathrooms: 12,
        percent_leaking: 0,
        daily_leakage: 0,
        toilet_cost: 250,
        water_cost_per_gallon: 0.00764
      }
    end

    let!(:after_inputs) do
      before_inputs
    end

    it { should_get_water_savings(81_030) }
    it { should_get_cost_savings(619) }
    it { should_get_cost_of_measure(3000) }
    it { should_get_years_to_payback(4.8) }
  end

  context 'with leakage' do
    let!(:before_inputs) do
      {
        num_occupants: 20,
        num_bathrooms: 12,
        rated_gallons_per_flush: 1.6,
        percent_leaking: 1,
        daily_leakage: 22,
        toilet_cost: 250,
        flushes_per_day: 5,
        water_cost_per_gallon: 0.00844
      }
    end

    let!(:after_inputs) do
      before_inputs.merge(
        rated_gallons_per_flush: 1.28,
        percent_leaking: 0,
        daily_leakage: 0
      )
    end

    it { should_get_water_savings(108_040) }
    it { should_get_cost_savings(911.8) }
    it { should_get_cost_of_measure(3000) }
    it { should_get_years_to_payback(3.3) }
  end
end
