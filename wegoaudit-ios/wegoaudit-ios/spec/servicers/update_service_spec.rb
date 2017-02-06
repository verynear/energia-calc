describe 'UpdateService' do
  before do
    cdq.setup

    @params = { 'id' => NSUUID.UUID.UUIDString, nickname: 'foo' }
    @structure_type = StructureType.create_with_uuid(name: 'Building',
                                                     display_order: 1)
  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'updates the object' do
      Building.create(@params)
      new_params = { 'id' => @params['id'], nickname: 'foo' }
      service = UpdateService.new(object_class: Building, params: new_params)

      service.execute
      service.object.is_a?(Building).should == true
      service.object.name.should == 'foo'
    end

    it 'raises an error if the building does not exist' do
      service = UpdateService.new(object_class: Building, params: @params)

      lambda { service.execute }.should.raise(RuntimeError)
    end

    it 'updates a substructure that is attached as a parameter' do
      new_params = { 'id' => 'building_structure',
                     'name' => 'foo',
                     'physical_structure' => { 'nickname' => 'foo' } }
      CreationService.execute!(object_class: Structure,
                               params: full_building_params)
      service = UpdateService.new(object_class: Structure,
                                  params: new_params)

      service.execute
      service.object.physical_structure.name.should == 'foo'
      service.object.name.should == 'foo'
    end

    it 'updates substructure for each object if passed an array' do
      new_params = { 'id' => 'building_structure',
                     'substructures' => [{ 'id' => 'meter_structure',
                                           'name' => 'foo',
                                           'physical_structure_id' => 'Meter' }] }
      CreationService.execute!(object_class: Structure,
                               params: full_building_params)
      service = UpdateService.new(object_class: Structure,
                                    params: new_params)
      service.execute

      meter_structure = Structure.where(physical_structure_type: 'Meter')
                                 .first
      meter_structure.name.should == 'foo'
    end

    it 'updates field values for a structure' do
      field_value_params = { 'id' => NSUUID.UUID.UUIDString }
      @params['field_values'] = [field_value_params]
      CreationService.execute!(object_class: Structure, params: @params)
      FieldValue.count.should == 1

      field_value_params['string_value'] = 'foo'
      service = UpdateService.new(object_class: Structure, params: @params)
      service.execute

      FieldValue.count.should == 1
      field_value = FieldValue.where(id: field_value_params['id']).first
      field_value.string_value.should == 'foo'
    end

    it 'updates sub-sample groups for a structure' do
      sample_group_params = { 'id' => NSUUID.UUID.UUIDString }
      @params['sample_groups'] = [sample_group_params]
      CreationService.execute!(object_class: Structure, params: @params)

      sample_group_params['name'] = 'foo'
      service = UpdateService.new(object_class: Structure, params: @params)
      service.execute

      sample_group = SampleGroup.where(id: sample_group_params['id']).first
      sample_group.name.should == 'foo'
    end

    it 'updates substructures for a sample group' do
      structure_params = { 'id' => NSUUID.UUID.UUIDString }
      @params['substructures'] = [structure_params]
      CreationService.execute!(object_class: SampleGroup, params: @params)

      structure_params['name'] = 'foo'
      service = UpdateService.new(object_class: SampleGroup, params: @params)
      service.execute

      structure = Structure.where(id: structure_params['id']).first
      structure.name.should == 'foo'
    end

    it 'destroys a substructure that no longer exists under a structure' do
      parent_structure = Structure.create_with_uuid
      child_structure = Structure.create_with_uuid(
        parent_structure_id: parent_structure.id
      )

      Structure.count.should == 2
      UpdateService.execute(object_class: Structure,
                            params: { 'id' => parent_structure.id, 'substructures' => [] })
      Structure.count.should == 1
    end

    it 'destroys a structure that no longer exists under a sample group' do
      sample_group = SampleGroup.create_with_uuid
      structure = Structure.create_with_uuid(
        sample_group_id: sample_group.id
      )

      Structure.count.should == 1
      UpdateService.execute(object_class: SampleGroup,
                            params: { 'id' => sample_group.id, 'substructures' => [] })
      Structure.count.should == 0
    end

    it 'destroys a sample group that no longer exists under a structure' do
      parent_structure = Structure.create_with_uuid
      sample_group = SampleGroup.create_with_uuid(
        parent_structure_id: parent_structure.id
      )

      SampleGroup.count.should == 1
      UpdateService.execute(object_class: Structure,
                            params: { 'id' => parent_structure.id, 'sample_groups' => [] })
      SampleGroup.count.should == 0
    end

    it 'does not destroy a structure image if the params do not pass structure_images' do
      parent_structure = Structure.create_with_uuid
      image = StructureImage.create_with_uuid(structure_id: parent_structure.id)

      StructureImage.count.should == 1
      UpdateService.execute(
        object_class: Structure,
        params: { 'id' => parent_structure.id }
      )
      StructureImage.count.should == 1
    end

    it 'destroys a structure image that no longer exists under a structure' do
      parent_structure = Structure.create_with_uuid
      image = StructureImage.create_with_uuid(structure_id: parent_structure.id)

      StructureImage.count.should == 1
      UpdateService.execute(
        object_class: Structure,
        params: { 'id' => parent_structure.id, 'structure_images' => [] }
      )
      StructureImage.count.should == 0
    end

    it 'creates a physical_structure if it does not exist' do
      new_params = { 'id' => 'building_structure',
                     'physical_structure' => full_building_params['physical_structure'] }
      CreationService.execute!(object_class: Structure,
                               params: full_building_params.except!('physical_structure'))
      service = UpdateService.new(object_class: Structure,
                                  params: full_building_params)

      Building.count.should == 0
      service.execute
      Building.count.should == 1
    end

    it 'creates fields values if they do not exist' do
      date_field = Field.create_with_uuid(value_type: 'date', name: 'DateField', id: 'date_field')
      string_field = Field.create_with_uuid(value_type: 'string', name: 'StringField', id: 'string_field')

      field_value_count_before = FieldValue.count
      CreationService.execute!(object_class: Structure,
                               params: full_building_params)
      service = UpdateService.new(object_class: Structure,
                                  params: full_building_params)
      service.execute
      FieldValue.count.should == field_value_count_before + 2

      date_field_value = FieldValue.where(id: 'date_field_value').first
      date_field_value.date_value.to_s.should.match /^2014-11-15/
    end
  end
end
