require 'rails_helper'

describe WegoBuilding do
  let(:user) { create(:user, username: 'fozzy') }
  let(:building) { described_class.new(user) }

  describe 'index_path' do
    it 'returns the correct url' do
      expect(building.index_path)
        .to eq('/api/v1/wego_pro/buildings')
    end
  end
 end
