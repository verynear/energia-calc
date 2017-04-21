require 'rails_helper'

describe Retrocalc::MeasuresController do
  describe '#index' do
    let!(:measure1) { create(:measure, name: 'first measure') }
    let!(:measure2) { create(:measure, name: 'second measure') }

    it 'responds with a success status code without wegowise_id set' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'returns a list of available measures' do
      allow(Measure).to receive(:all).and_return([measure1, measure2])

      get :index, wegowise_id: 3
      expect(JSON.parse(response.body)['measures'])
        .to eq([{'name' => 'first measure',
                 'api_name' => 'first_measure'
                },
                {'name' => 'second measure',
                 'api_name' => 'second_measure'
                }])
    end
  end
end
