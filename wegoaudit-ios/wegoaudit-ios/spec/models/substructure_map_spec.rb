describe 'SubstructureMap' do
  before do
    cdq.setup

    @audit_structure_type = StructureType.create_with_uuid(name: 'Audit',
                                                           primary: true)
    @structure = Structure.create_with_uuid(name: 'Audit 1',
                                            structure_type_id: @audit_structure_type.id)

    @building_structure_type = StructureType.create_with_uuid(
      name: 'Building',
      active: true,
      display_order: 1,
      parent_structure_type_id: @audit_structure_type.id,
      primary: true)

    @mechanical_structure_type = StructureType.create_with_uuid(
      name: 'Mechanical Equipment',
      active: true,
      display_order: 2,
      parent_structure_type_id: @audit_structure_type.id,
      primary: true)
  end

  after do
    cdq.reset!
  end

  describe '.objectAtIndexPath' do
    it 'returns nil if there is no object at the indexPath' do
      map = SubstructureMap.new(@structure)
      indexPath = NSIndexPath.indexPathForRow(0, inSection: 0)
      map.objectAtIndexPath(indexPath).should == nil
    end

    it 'returns the object at the indexPath' do
      substructure = Structure.create_with_uuid(
        name: 'A building',
        structure_type_id: @building_structure_type.id,
        parent_structure_id: @structure.id)
      map = SubstructureMap.new(@structure)
      indexPath = NSIndexPath.indexPathForRow(0, inSection: 0)
      map.objectAtIndexPath(indexPath).should == substructure
    end
  end

  describe '.section' do
    it 'returns nil if the section does not exist' do
      map = SubstructureMap.new(@structure)
      map.section(5).should == nil
    end

    it 'returns the section name if the section exists' do
      substructure = Structure.create_with_uuid(
        name: 'A building',
        structure_type_id: @building_structure_type.id,
        parent_structure_id: @structure.id)
      map = SubstructureMap.new(@structure)
      map.section(0).should == [substructure]
    end
  end

  describe '.section_name' do
    it 'returns nil if the section does not exist' do
      map = SubstructureMap.new(@structure)
      map.section_name(5).should == nil
    end

    it 'returns the section name if the section exists' do
      substructure = Structure.create_with_uuid(
        name: 'A building',
        structure_type_id: @building_structure_type.id,
        parent_structure_id: @structure.id)
      map = SubstructureMap.new(@structure)
      map.section_name(0).should == 'Building'
    end
  end

  describe '.section_count' do
    it 'returns the number of sections' do
      map = SubstructureMap.new(@structure)
      map.section_count.should == 2
    end
  end

  it 'does not include destroyed substructures' do
    substructure = Structure.create_with_uuid(
      name: 'A building',
      structure_type_id: @building_structure_type.id,
      parent_structure_id: @structure.id)
    destroyed_structure = Structure.create(id: 'destroyed_building_structure',
                                           parent_structure_id: @structure.id,
                                           name: 'Foo',
                                           structure_type_id: @building_structure_type.id,
                                           destroy_attempt_on: Time.now)
    map = SubstructureMap.new(@structure)
    map.section(0).count.should == 1
  end
end
