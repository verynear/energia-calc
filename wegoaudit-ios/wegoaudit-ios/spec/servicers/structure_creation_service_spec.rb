describe 'StructureCreationService' do
  before do
    cdq.setup


    @structure_type = StructureType.create_with_uuid(name: 'Building',
                                                     physical_structure_type: 'Building')
    @structure = Structure.create_with_uuid(name: 'Audit 1')
    @params = { params: { name: '10 Main St' },
                          structure_type: @structure_type }

  end

  after do
    cdq.reset!
  end

  describe 'execute' do
    it 'creates a new structure' do
      before_count = Structure.count
      StructureCreationService.execute!(@params)
      Structure.count.should == before_count + 1
    end

    it 'does not associate the new structure with an existing structure if not specified' do
      service = StructureCreationService.new(@params)
      service.execute!
      service.structure.parent_structure.should == nil
    end

    it 'assigns the new structure as a child of the parent structure' do
      service = StructureCreationService.new(@params.merge(parent_structure: @structure))
      service.execute!
      service.structure.parent_structure.should == @structure
    end

    it 'creates a physical_structure if the StructureType has a physical_structure_type' do
      before_count = Building.count
      StructureCreationService.execute!(@params)
      Building.count.should == before_count + 1
    end

    it "assigns the name to the physical_structure's name field" do
      service = StructureCreationService.new(@params)
      service.execute
      service.structure.physical_structure.nickname.should == '10 Main St'
    end
  end
end
