require 'rails_helper'

describe SessionsController, :devise do
  let(:user) { build(:user) }

  before do
    user = double('user')
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe '#create' do
    it 'creates a user' do
      expect {post "/devise/sessions", :params => {provider: :wegowise}}.to change{ User.count }.by(1)
    end

    it 'creates a session' do
      expect(session[:user_id]).to be_nil
      post "/devise/sessions", :params => {provider: :wegowise}
      expect(session[:user_id]).not_to be_nil
    end

    it 'redirects to the home page' do
      post "/devise/sessions", :params => {provider: :wegowise}
      expect(response).to redirect_to root_url
    end
  end

  describe '#destroy' do
    before do
      post :create, provider: :wegowise
    end

    it 'resets the session' do
      expect(session[:user_id]).not_to be_nil
      delete "/devise/sessions"
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the home page' do
      delete "/devise/sessions"
      expect(response).to redirect_to root_url
    end
  end
end
