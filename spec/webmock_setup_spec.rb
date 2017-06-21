require 'rails_helper'

feature 'WebmockHelpers' do
  it 'blocks unexpected remote connections' do
    expect { Net::HTTP.get(URI('http://google.com')) }
      .to raise_error(WebMock::NetConnectNotAllowedError)
  end

  it 'blocks unexpected localhost connections' do
    expect { Net::HTTP.get(URI('http://127.0.0.1')) }
      .to raise_error(WebMock::NetConnectNotAllowedError)
  end

  it 'blocks unexpected localhost connections on a port' do
    expect { Net::HTTP.get(URI('http://127.0.0.1:42424')) }
      .to raise_error(WebMock::NetConnectNotAllowedError)
  end
end
