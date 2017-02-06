describe 'CreationService' do
  before do
    @params = { 'id' => NSUUID.UUID.UUIDString }
    @structure_type = StructureType.create_with_uuid(name: 'Building',
                                                     display_order: 1)
    cdq.setup
  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a physical structure' do
      service = CreationService.new(object_class: Building, params: @params)

      before_count = Building.count
      service.execute

      Building.count.should == before_count + 1
    end

    it 'raises an error if the building already exists' do
      Building.create(@params)
      service = CreationService.new(object_class: Building, params: @params)

      lambda { service.execute }.should.raise(RuntimeError)
    end

    it 'creates a substructure that is attached as a parameter' do
      service = CreationService.new(object_class: Structure,
                                    params: full_building_params)

      service.execute
      Structure.count.should == 3
      Building.count.should == 1
      service.object.is_a?(Structure).should == true
      service.object.physical_structure.is_a?(Building).should == true
    end

    it 'creates substructure for each object if passed an array' do
      service = CreationService.new(object_class: Structure,
                                    params: full_building_params)
      service.execute
      Structure.count.should == 3
      Building.count.should == 1
      Meter.count.should == 1
      Apartment.count.should == 1
    end

    it 'creates field values for a structure' do
      @params['field_values'] = [{ 'id' => NSUUID.UUID.UUIDString }]
      service = CreationService.new(object_class: Structure, params: @params)
      before_count = FieldValue.count
      service.execute
      FieldValue.count.should == before_count + 1
    end

    it 'creates substructures for a sample group' do
      @params['substructures'] = [{ 'id' => NSUUID.UUID.UUIDString }]
      service = CreationService.new(object_class: SampleGroup, params: @params)
      before_count = SampleGroup.count
      service.execute
      SampleGroup.count.should == before_count + 1
    end

    it 'creates substructures for a structure' do
      @params['substructures'] = [{ 'id' => NSUUID.UUID.UUIDString }]
      service = CreationService.new(object_class: Structure, params: @params)
      before_count = Structure.count
      service.execute
      Structure.count.should == before_count + 2
    end

    it 'updates substructures if they already exist' do
      building_params = full_building_params['physical_structure']
        .except('type', 'state', 'created_at', 'updated_at')
      building = Building.create(building_params.merge(name: 'foo'))
      service = CreationService.new(object_class: Structure,
                                    params: full_building_params)

      building.name.should == 'foo'
      building.id.should == 'building_object'
      service.execute
      updated_building = Building.first
      updated_building.name.should == '10 Greene Street'
      updated_building.id.should == 'building_object'
    end
  end
end
