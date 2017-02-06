require 'rails_helper'

describe SessionsController, :omniauth do
  let(:user) { build(:user) }

  before do
    request.env['omniauth.auth'] = auth_mock(user)
    allow(WegoUser).to receive(:new).and_return(double(show: {}))
  end

  describe '#create' do
    it 'creates a user' do
      expect {post :create, provider: :wegowise}.to change{ User.count }.by(1)
    end

    it 'creates a session' do
      expect(session[:user_id]).to be_nil
      post :create, provider: :wegowise
      expect(session[:user_id]).not_to be_nil
    end

    it 'redirects to the home page' do
      post :create, provider: :wegowise
      expect(response).to redirect_to root_url
    end
  end

  describe '#destroy' do
    before do
      post :create, provider: :wegowise
    end

    it 'resets the session' do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the home page' do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
