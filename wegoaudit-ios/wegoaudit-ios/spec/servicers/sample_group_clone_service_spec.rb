describe 'SampleGroupCloneService' do
  before do
    cdq.setup

    @audit_type = StructureType.create_with_uuid(name: 'Audit')
    @parent_structure = Structure.create_with_uuid(name: 'Audit 1',
      structure_type_id: @audit_type.id)
    @structure_type = StructureType.create_with_uuid(name: 'Common Area')
    @sample_group = SampleGroup.create_with_uuid(
      name: 'Commoner Area',
      structure_type_id: @structure_type.id,
      parent_structure_id: @parent_structure.id)
    @params = { params: { name: 'Commonest Area' },
                sample_group: @sample_group }
  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a new sample group' do
      before_count = SampleGroup.count
      SampleGroupCloneService.execute!(@params)
      SampleGroup.count.should == before_count + 1
    end

    it 'assigns the new sample group as a child of the parent structure' do
      service = SampleGroupCloneService.new(@params)
      service.execute!
      service.cloned_sample_group.parent_structure.should == @parent_structure
    end

    it 'clones substructures' do
      substructure1 = Structure.create_with_uuid(name: 'com 1',
        sample_group_id: @sample_group.id)
      substructure2 = Structure.create_with_uuid(name: 'com 2',
        sample_group_id: @sample_group.id)

      before_count = Structure.count
      service = SampleGroupCloneService.new(@params)
      service.execute
      Structure.count.should == before_count + 2
      service.cloned_sample_group.substructures.count.should == 2
      names = service.cloned_sample_group.substructures.map(&:name)
      names.include?('com 1').should == true
      names.include?('com 2').should == true
    end
  end
end

