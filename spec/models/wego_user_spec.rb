require 'rails_helper'

describe WegoUser do
  let(:survey_user) { create(:user, username: 'fozzy') }
  let(:user) { described_class.new(survey_user) }
  let(:wego_path) { '/api/v1/wego_pro/user' }

  describe 'show_path' do
    it 'returns the correct url' do
      expect(user.show_path)
        .to eq(wego_path)
    end
  end

  describe 'show' do
    it 'makes a call to wegowise with the correct parameters' do
      expect(user).to receive(:make_wego_call).with(:get, wego_path)
      user.show
    end

    it 'returns a hash of parameters when successful' do
      mock_access_token_request(:get, successful_response(wegowise_user_params))
      expect(user.show).to eq(wegowise_user_params)
    end

    it 'returns nil when unauthorized' do
      mock_access_token_request(:get, unauthorized)
      expect(user.show).to be_nil
      expect(user.response.status).to eq('401')
    end
  end

  def mock_access_token_request(method = :get, response = {})
    mock_access_token = instance_double(OAuth::AccessToken)
    expect(mock_access_token).to receive(:request).and_return(response)
    expect(user).to receive(:access_token).and_return(mock_access_token)
  end

  def successful_response(response)
    double(status: '200', body: response.to_json)
  end

  def unauthorized
    double(status: '401', body: nil)
  end

  def wegowise_user_params
    { id: survey_user.wegowise_id,
      username: 'api_user',
      phone: '(123) 456 - 7890',
      person_id: 1,
      first_name: 'Fozzie',
      last_name: 'Bear',
      organization: 'Muppet Show' }.with_indifferent_access
  end
end
