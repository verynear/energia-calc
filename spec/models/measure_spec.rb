require 'rails_helper'

describe Measure do
  it { should have_many :measure_values }
  it { should validate_presence_of :name }

  it 'does not allow changing api_name' do
    measure = create(:measure, name: 'This is my Name')
    measure.api_name = 'foo'
    expect(measure).to_not be_valid
    expect(measure.errors[:api_name]).to eq(["Can't change api_name"])
  end

  it 'sets its api_name based on name' do
    measure = create(:measure, name: 'This is my Name')
    expect(measure.api_name).to eq('this_is_my_name')
  end

  describe '.active / .inactive' do
    let!(:active_measure) { create(:measure, name: 'Active measure', active: true) }
    let!(:inactive_measure) { create(:measure, name: 'Inactive measure', active: false) }

    it 'returns active measures' do
      expect(described_class.active).to eq [active_measure]
    end

    it 'returns inactive measures' do
      expect(described_class.inactive).to eq [inactive_measure]
    end
  end
end
