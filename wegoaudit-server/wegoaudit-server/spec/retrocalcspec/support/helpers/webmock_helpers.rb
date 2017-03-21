module WebmockHelpers
  def self.capybara_port
    31_338 + ENV.fetch('TDDIUM_TID', 0).to_i
  end

  def self.capybara_url
    "127.0.0.1:#{capybara_port}/__identify__"
  end

  def self.stub
    Capybara.server_port = capybara_port
    WebMock.disable_net_connect!
    WebMock::Config.instance.allow = [/#{capybara_url}/]
    WebMock::Config.instance.allow += [%r{hub/session}]
  end

  def self.unstub_domain(domain)
    stubbed = WebMock::StubRegistry.instance.request_stubs.find do |request_stub|
      request_stub.request_pattern.uri_pattern.matches? domain
    end

    WebMock::API.remove_request_stub(stubbed) if stubbed
  end
end
