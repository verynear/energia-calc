class WegowiseClient
  attr_accessor :base_uri,
                :response,
                :user

  def initialize(wegowise_url: nil, user:)
    wegowise_url ||= Rails.application.secrets.wegowise_url
    @base_uri = wegowise_url
    @user = user
  end

  def organizations
    get "#{api_base}/organizations"
  end

  def structure_monthly_data(structure_type, wegowise_id, data_type, unit)
    structure_type = structure_type.downcase.pluralize

    get "#{api_base}/#{structure_type}/#{wegowise_id}/data" \
        "?data_type=#{data_type}&unit=#{unit}"
  end

  def success?
    response.code.to_s == '200'
  end

  private

  def access_token
    consumer = OAuth::Consumer.new(
      Rails.application.secrets.omniauth_provider_key,
      Rails.application.secrets.omniauth_provider_secret,
      site: base_uri)
    token_hash = { oauth_token: user.token,
                   oauth_token_secret: user.secret }

    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def api_base
    '/api/v1/wego_pro'
  end

  def get(path, options = {})
    @response = access_token.request(
      :get,
      path,
      nil,
      { consumer_key: Rails.application.secrets.omniauth_provider_key },
      options,
      'Content-Type' => 'application/json',
      'HTTP_ACCEPT' => 'application/json')

    Oj.load(response.body) unless response.body.nil?
  end
end
