describe 'Building' do
  before do
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Building entity' do
    Building.entity_description.name.should == 'Building'
  end

  describe '#linked?' do
    it 'returns true if the building has a wegowise_id' do
      building = Building.new(wegowise_id: 42)
      building.linked?.should == true
    end

    it 'returns false if the building does not have a wegowise_id' do
      building = Building.new
      building.linked?.should == false
    end
  end
end
