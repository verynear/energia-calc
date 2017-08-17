require 'rails_helper'

describe User do
  it { should have_many(:audits) }
  it { should have_many(:organizations) }
  it { should have_many(:buildings) }

  describe '.authenticated' do
    it 'returns users who have a password and password_confirmation' do
      user = create(:user)
      expect(User.authenticated).to eq [user]
    end

    it 'does not return users who are missing a password or password_confirmation' do
      user = create(:user, password: nil, password_confirmation: nil)
      expect(User.authenticated).to be_empty
    end
  end

  describe 'email validations' do
    it { is_expected.to have_many(:measure_selections) }
    it { is_expected.to have_many(:audit_reports) }

    it { is_expected.to_not allow_value('name @domain.com').for(:email) }
    it { is_expected.to_not allow_value('name@domaincom').for(:email) }
    it { is_expected.to_not allow_value('namedomain.com').for(:email) }
    it { is_expected.to_not allow_value('name@domain.').for(:email) }
  end

  describe '#available_audits' do
    let!(:organization) { create(:organization) }
    let!(:user1) { organization.owner}
    let!(:user2) { create(:user) }
    let!(:audit1) { create(:audit, user: user1) }
    let!(:audit2) { create(:audit, user: user2) }


    it 'returns only audits for a user if they are not in an organization' do
      expect(user2.available_audits).to eq [audit2]
    end
  end

  describe '#has_authenticated?' do
    let(:user) { User.new }

    it 'returns true if the user has a password and password_confirmation' do
      user.password = 'password'
      user.password_confirmation = 'password'
      expect(user.has_authenticated?).to eq true
    end

    it 'returns false if the user is missing a password' do
      user.password = nil
      user.password_confirmation = 'password_confirmation'
      expect(user.has_authenticated?).to eq false
    end

    it 'returns false if the user is missing a password_confirmation' do
      user.password = 'password'
      user.password_confirmation = nil
      expect(user.has_authenticated?).to eq false
    end

    it 'returns false if the user is missing a password and password_confirmation' do
      user.password = nil
      user.password_confirmation = nil
      expect(user.has_authenticated?).to eq false
    end
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
