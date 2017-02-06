describe 'SampleCreationService' do
  before do
    cdq.setup

    @structure_type = StructureType.create_with_uuid(name: 'Hallway')
    @params = { params: { name: '1st Floor' }, structure_type: @structure_type }
  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a new structure' do
      before_count = Structure.count
      SampleCreationService.execute!(@params)
      Structure.count.should == before_count + 1
    end

    it 'does not associate the new structure with an existing structure' do
      service = SampleCreationService.new(@params)
      service.execute!
      service.structure.parent_structure.should == nil
    end

    it 'assigns the new structure as a child of the sample group' do
      sample_group = SampleGroup.create_with_uuid(
        name: 'Hallways',
        n_structures: 1,
        structure_type_id: @structure_type.id)
      service = SampleCreationService.new(
        @params.merge(sample_group: sample_group))
      service.execute!
      service.structure.parent_sample_group.should == sample_group
    end
  end
end
