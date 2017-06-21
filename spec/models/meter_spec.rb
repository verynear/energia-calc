require 'rails_helper'

describe Meter do
  let!(:audit_strc_type) { create(:meter_audit_strc_type) }

  it { should have_many :audit_structures }

  describe '.audit_strc_type' do
    it 'retrieves the structure_type for meters' do
      expect(Meter.audit_strc_type).to eq audit_strc_type
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
