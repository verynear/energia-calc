describe 'StructureDestroyer' do
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

  describe 'execute when structure has not been uploaded' do
    it 'destroys field values' do
      field = Field.create_with_uuid(name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: @structure.id,
                                   string_value: 'foo')
      before_count = FieldValue.count
      service = StructureDestroyer.new(structure: @structure)
      service.execute
      FieldValue.count.should == before_count - 1
    end

    it 'destroys any substructures' do
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
      service = StructureDestroyer.new(structure: @structure)
      service.execute
      Structure.count.should == before_count - 3
      FieldValue.count.should == before_field_value_count - 1
    end

    it 'destroys any sample groups' do
      sample_group1 = SampleGroup.create_with_uuid(name: 'apt 1',
        parent_structure_id: @structure.id)
      sample_group2 = SampleGroup.create_with_uuid(name: 'apt 2',
        parent_structure_id: @structure.id)

      SampleGroup.count.should == 2
      service = StructureDestroyer.new(structure: @structure)
      service.execute
      SampleGroup.count.should == 0
    end

    it 'destroys the structure' do
      before_count = Structure.count
      StructureDestroyer.execute!(structure: @structure)
      Structure.count.should == before_count - 1
    end

    it 'destroys the physical_structure' do
      building = Building.create_with_uuid(nickname: '121 Farnsworth Rd')
      @structure.physical_structure = building
      before_count = Building.count
      StructureDestroyer.execute!(structure: @structure)
      Building.count.should == before_count - 1
    end

    it 'destroys any images' do
      File.stub!(:unlink)
      image = StructureImage.create_with_uuid(structure_id: @structure.id)

      before_image_count = StructureImage.count
      StructureDestroyer.execute!(structure: @structure)
      StructureImage.count.should == before_image_count - 1
    end
  end

  describe 'execute when structure has been uploaded' do
    before do
      @time = Time.mktime('2014', '12', '22')

      Time.stub!(:now).and_return(@time)
    end

    it 'sets the field_value destroy_attempt_on' do
      field = Field.create_with_uuid(name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: @structure.id,
                                   string_value: 'foo',
                                   successful_upload_on: Time.now)

      service = StructureDestroyer.new(structure: @structure)
      service.execute

      field_value.destroy_attempt_on.should == @time
    end

    it 'sets the substructures destroy_attempt_on' do
      substructure1 = Structure.create_with_uuid(name: 'apt 1',
        parent_structure_id: @structure.id,
        successful_upload_on: Time.now)
      substructure2 = Structure.create_with_uuid(name: 'apt 2',
        parent_structure_id: @structure.id,
        successful_upload_on: Time.now)
      field = Field.create_with_uuid(name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: substructure2.id,
                                   string_value: 'foo',
                                   successful_upload_on: Time.now)

      service = StructureDestroyer.new(structure: @structure)
      service.execute

      substructure1.destroy_attempt_on.should == @time
      substructure2.destroy_attempt_on.should == @time
      field_value.destroy_attempt_on.should == @time
    end

    it 'sets the structure destroy_attempt_on' do
      @structure.successful_upload_on = Time.now
      StructureDestroyer.execute!(structure: @structure)
      @structure.destroy_attempt_on.should == @time
    end

    it 'sets the physical_structure destroy_attempt_on' do
      building = Building.create_with_uuid(nickname: '121 Farnsworth Rd',
                                           successful_upload_on: Time.now)
      @structure.physical_structure = building

      StructureDestroyer.execute!(structure: @structure)
      building.destroy_attempt_on.should == @time
    end

    it 'sets the structure_image destroy_attempt_on' do
      image = StructureImage.create_with_uuid(structure_id: @structure.id,
                                              successful_upload_on: Time.now)
      @structure.successful_upload_on = Time.now
      File.stub!(:unlink)

      StructureDestroyer.execute!(structure: @structure)

      image.destroy_attempt_on.should == @time
    end
  end
end
