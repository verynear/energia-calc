describe 'StructureCloneService' do
  before do
    cdq.setup


    @audit_type = StructureType.create_with_uuid(name: 'Audit')
    @parent_structure = Structure.create_with_uuid(name: 'Audit 1',
      structure_type_id: @audit_type.id)
    @structure_type = StructureType.create_with_uuid(name: 'Building',
      physical_structure_type: 'Building')
    @structure = Structure.create_with_uuid(name: 'Building',
      structure_type_id: @structure_type.id,
      parent_structure_id: @parent_structure.id)
    @params = { params: { name: '10 Main St' },
                structure: @structure }

  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a new structure' do
      before_count = Structure.count
      StructureCloneService.execute!(@params)
      Structure.count.should == before_count + 1
    end

    it 'assigns the new structure as a child of the parent structure' do
      service = StructureCloneService.new(@params)
      service.execute!
      service.cloned_structure.parent_structure.should == @parent_structure
    end

    it 'creates a physical_structure if the Structure has a physical_structure' do
      building = Building.create_with_uuid(nickname: '121 Farnsworth Rd')
      @structure.physical_structure = building
      before_count = Building.count
      StructureCloneService.execute!(params: { name: '10 Main St' },
                                     structure: @structure)
      Building.count.should == before_count + 1
    end

    it 'clones field values' do
      field = Field.create_with_uuid(name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: @structure.id,
                                   string_value: 'foo')
      before_count = FieldValue.count
      service = StructureCloneService.new(@params)
      service.execute
      FieldValue.count.should == before_count + 1
      service.cloned_structure.field_values.count.should == 1
      service.cloned_structure.field_values.first.string_value.should == 'foo'
    end

    it 'clones sample groups' do
      sample_group1 = SampleGroup.create_with_uuid(
        name: 'apts 1',
        parent_structure_id: @structure.id)
      sample_group2 = SampleGroup.create_with_uuid(
        name: 'apts 2',
        parent_structure_id: @structure.id)

      before_count = SampleGroup.count
      service = StructureCloneService.new(@params)
      service.execute
      SampleGroup.count.should == before_count + 2
      names = service.cloned_structure.sample_groups.map(&:name)
      names.include?('apts 1').should == true
      names.include?('apts 2').should == true
    end

    it 'clones substructures' do
      substructure1 = Structure.create_with_uuid(name: 'apt 1',
        parent_structure_id: @structure.id)
      substructure2 = Structure.create_with_uuid(name: 'apt 2',
        parent_structure_id: @structure.id)
      field = Field.create_with_uuid(name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: substructure2.id,
                                   string_value: 'foo')
      before_count = Structure.count
      before_field_value_count = FieldValue.count
      service = StructureCloneService.new(@params)
      service.execute
      Structure.count.should == before_count + 3
      service.cloned_structure.substructures.count.should == 2
      names = service.cloned_structure.substructures.map(&:name)
      names.include?('apt 1').should == true
      names.include?('apt 2').should == true
      FieldValue.count.should == before_field_value_count + 1
    end
  end
end
