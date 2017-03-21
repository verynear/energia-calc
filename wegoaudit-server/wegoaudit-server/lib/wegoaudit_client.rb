class WegoauditClient
  attr_accessor :base_uri,
                :wegowise_id,
                :organization_id

  class ApiError < StandardError
    attr_reader :code

    def initialize(message, code = nil)
      @code = code
      super(message)
    end
  end

  def initialize(organization_id: nil, wegoaudit_url: nil)
    self.organization_id = organization_id
    wegoaudit_url ||= Retrocalc::WEGOAUDIT_URL
    self.base_uri = wegoaudit_url
  end

  def audit(audit_id)
    raise ArgumentError unless audit_id.present?

    response = get("/audits/#{audit_id}", query: { organization_id: organization_id })

    error = response.body['error']

    if error
      raise WegoauditClient::ApiError.new(error['message'], error['code'])
    else
      response.body['audit']
    end
  end

  def audits_list
    response = get('/audits', query: { organization_id: organization_id })

    error = response.body['error']

    if error && error['code'] == 'user_not_found'
      []
    elsif error
      raise WegoauditClient::ApiError.new(error['message'], error['code'])
    else
      response.body['audits']
    end
  end

  def fields_list
    response = get('/fields')

    error = response.body['error']

    if error
      raise WegoauditClient::ApiError.new(error['message'], error['code'])
    else
      response.body['fields']
    end
  end

  def measures_list
    response = get('/measures')

    error = response.body['error']

    if error
      raise WegoauditClient::ApiError.new(error['message'], error['code'])
    else
      response.body['measures']
    end
  end

  def structure_types_list
    response = get('/structure_types')

    error = response.body['error']

    if error
      raise WegoauditClient::ApiError.new(error['message'], error['code'])
    else
      response.body['structure_types']
    end
  end

  private

  def get(path, options = {})
    connection = Faraday.new(url: base_uri) do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.options.timeout = 600
      faraday.adapter Faraday.default_adapter
      basic_auth = DoorStop.authify(Retrocalc::DOORSTOP_SHARED_SECRET)
      faraday.basic_auth(basic_auth[:username], basic_auth[:password])
      faraday.response :oj
    end
    connection.get("/retrocalc#{path}", options[:query])
  end
end
