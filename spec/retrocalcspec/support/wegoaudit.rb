module WegoauditSupport
  def audit_payload(data)
    payload = { 'audit' => data }
    expect(payload).to match_response_schema('retrocalc/audit')
    payload
  end

  def stub_wegoaudit_request(action, **options)
    request_type = options.fetch(:request_type, :get)
    status = options.fetch(:status, 200)
    query = options.fetch(:query, nil)

    allow(DoorStop).to receive(:authify).with('s3kr3t')
      .and_return(username: 'username', password: 'password')

    stubbed = stub_request(
      request_type,
      'http://username:password@' \
      "#{Retrocalc::WEGOAUDIT_URL.gsub(%r{https?://}, '')}/retrocalc#{action}")
      .with(headers: { 'Content-Type' => 'application/json' })

    stubbed = stubbed.with(query: query) if query

    body = yield
    body = body.to_json if body.is_a?(Hash)

    stubbed.to_return(status: status, body: body)
  end
end
