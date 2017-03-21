require 'rails_helper'

describe User do
  describe 'email validations' do
    it { is_expected.to have_many(:measure_selections) }
    it { is_expected.to have_many(:audit_reports) }

    it { is_expected.to_not allow_value('name @domain.com').for(:email) }
    it { is_expected.to_not allow_value('name@domaincom').for(:email) }
    it { is_expected.to_not allow_value('namedomain.com').for(:email) }
    it { is_expected.to_not allow_value('name@domain.').for(:email) }
  end

  context 'when user is not associated with organization' do
    let!(:user) { create(:user) }

    specify '#available_reports returns an empty list' do
      expect(user.available_reports.count).to eq 0
    end

    specify '#available_templates returns an empty list' do
      expect(user.available_templates.count).to eq 0
    end
  end
end
