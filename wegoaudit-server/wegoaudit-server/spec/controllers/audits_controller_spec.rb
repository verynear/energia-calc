require 'rails_helper'

describe AuditsController do
  let(:user) { create(:user) }
  let(:audit) { create(:audit, user: user) }

  before { session[:user_id] = user.id }

  describe 'POST lock' do
    it 'acquires a lock on the audit' do
      post :lock, id: audit.id
      audit.reload

      expect(response).to have_http_status(:ok)
      expect(audit.locked_by_user).to eq user
    end

    it 'is successful if the user already has a lock' do
      audit.locked_by_user = user

      post :lock, id: audit.id

      expect(response).to have_http_status(:ok)
      expect(audit.locked_by_user).to eq user
    end

    it 'receives an error if the audit is locked by someone else' do
      user2 = create(:user)
      audit.update_attribute(:locked_by, user2.id)

      post :lock, id: audit.id

      expect(response).to have_http_status(:unauthorized)
      expect(audit.locked_by_user).to eq user2
    end

    it 'receives an error if the audit does not exist' do
      post :lock, id: SecureRandom.uuid
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST unlock' do
    it 'releases the lock on an audit' do
      audit.update_attribute(:locked_by, user.id)

      post :unlock, id: audit.id
      audit.reload

      expect(response).to have_http_status(:ok)
      expect(audit.is_locked?).to eq false
    end

    it 'returns an error if a different user has locked the audit' do
      user2 = create(:user)
      audit.update_attribute(:locked_by, user2.id)

      post :unlock, id: audit.id

      expect(response).to have_http_status(:unauthorized)
      expect(audit.locked_by_user).to eq user2
    end

    it 'is successful even if the audit is already unlocked' do
      post :unlock, id: audit.id
      audit.reload

      expect(response).to have_http_status(:ok)
      expect(audit.is_locked?).to eq false
    end

    it 'receives an error if the audit does not exist' do
      post :unlock, id: SecureRandom.uuid
      expect(response).to have_http_status(:not_found)
    end
  end
end
