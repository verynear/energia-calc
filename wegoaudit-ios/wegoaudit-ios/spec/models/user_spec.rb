describe 'User' do
  before do
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a User entity' do
    User.entity_description.name.should == 'User'
  end

  describe '.full_name' do
    it 'returns "first_name last_name"' do
      user = User.create(first_name: 'First', last_name: 'Last')
      user.full_name.should == 'First Last'
    end

    it 'does not include missing fields "first_name last_name"' do
      user = User.create(first_name: 'First')
      user.full_name.should == 'First'
    end

    it 'returns "last_name, first_name" if the first argument is true' do
      user = User.create(first_name: 'First', last_name: 'Last')
      user.full_name(true).should == 'Last, First'
    end
  end
end
