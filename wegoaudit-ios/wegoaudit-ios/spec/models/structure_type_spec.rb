describe 'StructureType' do
  before do
    cdq.setup

    @structure_type = StructureType.create_with_uuid(name: 'Structure Name')
  end

  after do
    cdq.reset!
  end

  describe '#is_subtype?' do
    it 'returns true if it has a parent structure type that is not primary' do
      parent_type = StructureType.create_with_uuid(
        name: 'Foo',
        primary: false)
      structure_type = StructureType.new(
        parent_structure_type_id: parent_type.id)
      structure_type.is_subtype?.should == true
    end

    it 'returns false if it has a parent structure type that is primary' do
      parent_type = StructureType.create_with_uuid(
        name: 'Foo',
        primary: true)
      structure_type = StructureType.new(
        parent_structure_type_id: parent_type.id)
      structure_type.is_subtype?.should == false
    end

    it 'returns false if it does not have a parent structure type' do
      structure_type = StructureType.new(primary: 0)
      structure_type.is_subtype?.should == false
    end
  end

  describe '.can_have_substructures?' do
    it 'returns true if there are substructure_types' do
      @structure_type.primary = 1
      substructure_type = StructureType.create_with_uuid(name: 'foo',
                                                         parent_structure_type_id: @structure_type.id)

      @structure_type.can_have_substructures?.should == true
    end

    it 'returns false if there are no substructure_types' do
      @structure_type.can_have_substructures?.should == false
    end
  end
end
