describe 'SampleGroup' do
  before do
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it '#parent_structure returns the parent_structure_id structure' do
    structure = Structure.create_with_uuid(name: 'Foo Structure')
    group = SampleGroup.create_with_uuid(name: 'Foo SampleGroup',
                                         parent_structure_id: structure.id)
    group.parent_structure.should == structure
  end

  it '#structure_type returns the structure_type_id structure type' do
    structure_type = StructureType.create_with_uuid(name: 'Foo StructureType')
    group = SampleGroup.create_with_uuid(name: 'Foo SampleGroup',
                                         structure_type_id: structure_type.id)
    group.structure_type.should == structure_type
  end

  it '#short_description returns the sample group name' do
    sample_group = SampleGroup.new(name: 'Foo')
    sample_group.short_description.should == 'Foo'
  end

  it '#long_description returns more information about the sample group' do
    structure_type = StructureType.new(name: 'Foo')
    sample_group = SampleGroup.new(name: 'Bar', n_structures: 4)
    sample_group.stub!(:structure_type).and_return(structure_type)
    sample_group.stub!(:substructures).and_return([:one, :two])
    sample_group.long_description.should == 'Foo - Bar (2 of 4)'
  end


  describe '#can_add_samples?' do
    it 'returns true if the sample group has < n_structures' do
      sample_group = SampleGroup.new(n_structures: 2)
      sample_group.stub!(:substructures).and_return([:sample])
      sample_group.can_add_samples?.should == true
    end

    it 'returns false if the sample group does not have < n_structures' do
      sample_group = SampleGroup.new(n_structures: 1)
      sample_group.stub!(:substructures).and_return([:sample])
      sample_group.can_add_samples?.should == false
    end
  end

  describe '#set_value' do
    it 'sets attributes' do
      sample_group = SampleGroup.new
      sample_group.set_value('name', 'foo')
      sample_group.name.should == 'foo'
    end

    it 'casts n_structures to an int' do
      sample_group = SampleGroup.new
      sample_group.set_value('n_structures', '4')
      sample_group.n_structures.should == 4
    end
  end

  describe '#presenter' do
    it 'returns a sample group presenter' do
      apartment = SampleGroup.new
      presenter = apartment.presenter
      presenter.class.should == SampleGroupDetailPresenter
      presenter.component.should == apartment
    end
  end
end
