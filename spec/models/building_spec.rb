require 'rails_helper'

describe Building do
  it { should have_many :organization_buildings }

  specify '#name= sets the nickname' do
    building = Building.new
    building.name = '201 South Street'
    expect(building.nickname).to eq '201 South Street'
  end

  specify '#name returns the nickname' do
    building = Building.new(nickname: '201 South Street')
    expect(building.name).to eq '201 South Street'
  end

  describe '.search_by_name' do
    let(:wego_building) do
      create(:building,
             cloned: false,
             nickname: 'Foo',
             wegowise_id: 42)
    end

    it 'returns buildings that match the searched nickname' do
      results = Building.search_by_name('fo')
      expect(results).to eq [wego_building]
    end

    it 'does not return cloned buildings' do
      create(:building,
             cloned: true,
             nickname: 'Foo cloned building')
      results = Building.search_by_name('fo')
      expect(results).to eq [wego_building]
    end

    it 'does not return buildings that are not linked to wegowise IDs' do
      create(:building,
             nickname: 'Foo draft building',
             wegowise_id: nil)
      results = Building.search_by_name('fo')
      expect(results).to eq [wego_building]
    end

    it 'sorts the building results by their nicknames' do
      wego_building2 = create(:building,
                              cloned: false,
                              nickname: 'Foo bar',
                              wegowise_id: 43)
      results = Building.search_by_name('fo')
      expect(results).to eq [wego_building, wego_building2]
    end
  end
end
