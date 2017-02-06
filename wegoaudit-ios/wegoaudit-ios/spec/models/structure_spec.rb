describe 'Structure' do
  before do
    cdq.setup
    @structure = Structure.create_with_uuid(name: 'Structure Name')
    @field1 = Field.create_with_uuid(name: 'Name')
    @field2 = Field.create_with_uuid(name: 'email')
    @field_value1 = FieldValue.create_with_uuid(structure_id: @structure.id,
                                                field_id: @field1.id)
    @field_value2 = FieldValue.create_with_uuid(structure_id: @structure.id,
                                                field_id: @field2.id)
  end

  after do
    cdq.reset!
  end

  describe '.field_values' do
    it 'returns all of the field values for the structure' do
      @structure.field_values.count.should == 2
    end
  end

  describe '.sample_groups' do
    it 'returns all sample groups under this structure' do
      group = SampleGroup.create_with_uuid(name: 'foo',
                                           parent_structure_id: @structure.id)
      @structure.sample_groups.to_a.should == [group]
    end
  end

  describe '#presenter' do
    it 'returns a physical structure presenter for physical structures' do
      building = Structure.new(physical_structure_type: 'Building')
      presenter = building.presenter
      presenter.class.should == BuildingDetailPresenter
      presenter.component.should == building
    end

    it 'returns a structure presenter for structures that are not physical' do
      lighting = Structure.new
      presenter = lighting.presenter
      presenter.class.should == StructureDetailPresenter
      presenter.component.should == lighting
    end
  end

  describe '#set_field_value' do
    it 'sets attributes on the structure' do
      structure = Structure.new
      structure.name.should == nil
      structure.set_field_value('name', 'Foo')
      structure.name.should == 'Foo'
    end
  end
end
