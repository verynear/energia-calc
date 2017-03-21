require 'rails_helper'

describe WegoauditClient do
  let(:client) { described_class.new(wegowise_id: 1) }

  describe '#audits_list' do
    it 'throws an exception if response contains an error code' do
      response = double(
        body: { 'error' => { 'code' => 'something_went_wrong',
                             'message' => 'Something went wrong' } }
      )

      stub_faraday_request('/audits', query: { wegowise_id: 1 })
        .and_return(response)

      expect { client.audits_list }
        .to raise_error(WegoauditClient::ApiError, 'Something went wrong')
    end

    it 'returns an empty array if error code is user_not_found' do
      response = double(
        body: {
          'error' => { 'code' => 'user_not_found' } }
      )

      stub_faraday_request('/audits', query: { wegowise_id: 1 })
        .and_return(response)

      expect(client.audits_list).to eq([])
    end

    it 'returns an array of audits if response is valid' do
      response = double(
        body: {
          'audits' => [:foo, :bar] }
      )

      allow(Wegoaudit::Audit).to receive(:new).with(:foo).and_return(:foo)
      allow(Wegoaudit::Audit).to receive(:new).with(:bar).and_return(:bar)

      stub_faraday_request('/audits', query: { wegowise_id: 1 })
        .and_return(response)

      expect(client.audits_list).to eq([:foo, :bar])
    end
  end

  describe '#audit' do
    it 'throws an exception if response contains an error code' do
      response = double(
        body: { 'error' => { 'code' => 'something_went_wrong',
                             'message' => 'Something went wrong' } }
      )

      stub_faraday_request('/audits/2', query: { wegowise_id: 1 })
        .and_return(response)

      expect { client.audit(2) }
        .to raise_error(WegoauditClient::ApiError, 'Something went wrong')
    end

    it 'returns a hash if response is valid' do
      response = double(
        body: {
          'audit' => {} }
      )

      stub_faraday_request('/audits/2', query: { wegowise_id: 1 })
        .and_return(response)

      expect(client.audit(2)).to eq({})
    end
  end

  describe '#measures_list' do
    it 'throws an exception if response contains an error code' do
      response = double(
        body: { 'error' => { 'code' => 'something_went_wrong',
                             'message' => 'Something went wrong' } }
      )

      stub_faraday_request('/measures').and_return(response)

      expect { client.measures_list }
        .to raise_error(WegoauditClient::ApiError, 'Something went wrong')
    end

    it 'returns an array of audits if response is valid' do
      response = double(
        body: {
          'measures' => [:foo, :bar] }
      )

      stub_faraday_request('/measures').and_return(response)

      expect(client.measures_list).to eq([:foo, :bar])
    end
  end

  def stub_faraday_request(path, options = {})
    connection = instance_double(Faraday::Connection)
    allow(Faraday).to receive(:new)
      .with(url: "#{Retrocalc::WEGOAUDIT_URL}")
      .and_return(connection)
    expect(connection).to receive(:get)
      .with("/retrocalc#{path}", options[:query])
  end
end
