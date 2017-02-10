module WegowiseClient
  attr_accessor :response

  def base_uri
    Rails.application.secrets.wegowise_url
  end

  def index
    make_wego_call(:get, "#{index_path}")
  end

  def index_path
    [api_base, object_base_path.pluralize].join('/')
  end

  def show(wegowise_id = nil)
    parameters = make_wego_call(:get, show_path(wegowise_id))
    parameters.with_indifferent_access if parameters
  end

  def show_path(wegowise_id = nil)
    [api_base, object_base_path, wegowise_id].compact.join('/')
  end

  def make_wego_call(method, path, json = nil)
    @response = access_token.request(method,
                                     path,
                                     nil,
                                     { consumer_key: Rails.application.secrets.omniauth_provider_key },
                                     json,
                                     { 'Content-Type' => 'application/json',
                                       'HTTP_ACCEPT' => 'application/json' })
    parse_body
  end

  def access_token
    # consumer = OAuth::Consumer.new(Rails.application.secrets.omniauth_provider_key,
    #                                Rails.application.secrets.omniauth_provider_secret,
    #                                site: base_uri)
    # token_hash = { oauth_token: user.token,
    #                oauth_token_secret: user.secret }
    # return OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def success?
    response.code.to_s == '200'
  end

  private

  def parse_body
    Oj.load(@response.body) unless @response.body.nil?
  end

  def api_base
    '/api/v1/wego_pro'
  end
end
