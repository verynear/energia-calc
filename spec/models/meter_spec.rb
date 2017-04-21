require 'rails_helper'

describe Meter do
  let!(:structure_type) { create(:meter_structure_type) }

  it { should have_many :structures }

  describe '.structure_type' do
    it 'retrieves the structure_type for meters' do
      expect(Meter.structure_type).to eq structure_type
    end
  end

  describe '.name=' do
    it 'sets the account_number' do
      meter = Meter.new
      meter.name = 'foo'
      expect(meter.account_number).to eq 'foo'
    end
  end

  describe '.name' do
    it 'returns the account_number' do
      meter = Meter.new(account_number: 'foo')
      expect(meter.name).to eq 'foo'
    end
  end
end
