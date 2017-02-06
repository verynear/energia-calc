describe 'StructureImage' do
  before do
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a StructureImage entity' do
    StructureImage.entity_description.name.should == 'StructureImage'
  end

  it 'generates the corresponding thumbnail_path' do
    image = StructureImage.new(structure_id: 'foo', id: 'bar')
    image.thumbnail_path.should == "#{App.documents_path}/foo - bar-thumb.jpg"
  end

  it 'generates the corresponding original_path' do
    image = StructureImage.new(structure_id: 'foo', id: 'bar')
    image.original_path.should == "#{App.documents_path}/foo - bar.jpg"
  end
end
