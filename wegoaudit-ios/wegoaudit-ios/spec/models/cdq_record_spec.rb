describe 'CDQRecord' do
  before do
    cdq.setup
    @field = Field.create_with_uuid(name: 'Name')
    @field_value = FieldValue.new(field_id: @field.id)
  end

  after do
    cdq.reset!
  end

  describe '#excluded_attributes' do
    it 'returns a list of attributes that should not be cloned' do
      @field.excluded_attributes.should == [
        'id',
        'successful_upload_on',
        'upload_attempt_on',
        'created_at',
        'updated_at'
      ]
    end

    it 'returns the correct synchronization_attribute for models' do
      User.new.excluded_attributes.should == [
        'wegowise_id',
        'successful_upload_on',
        'upload_attempt_on',
        'created_at',
        'updated_at'
      ]
    end
  end

  describe '#cloneable_attributes' do
    it 'does not return excluded attributes' do
      @field.cloneable_attributes.keys
        .include?(@field.excluded_attributes).should == false
    end

    it 'does not set the cloned attribute if the model cannot be cloned' do
      @field.cloneable_attributes.keys.include?('cloned').should == false
    end

    it 'sets the cloned attribute if the model can be cloned' do
      building = Building.new
      building.cloneable_attributes['cloned'].should == true
    end
  end

  describe '#clone' do
    it 'returns a new object with all cloneable attributes' do
      new_field = @field.clone
      new_field.id.should != @field.id
    end

    it 'overrides params' do
      new_field = @field.clone(name: 'Foo')
      new_field.name.should == 'Foo'
    end
  end

  # The FieldValue class contains all data types
  describe '.set_attribute' do
    it 'converts the value to a string' do
      @field_value.set_attribute(:string_value, 'foo')
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="integer" converts the value to an integer' do
      @field_value.set_attribute(:integer_value, '123')
      @field_value.integer_value.should == 123
    end

    it 'converts the value to a decimal' do
      @field_value.set_attribute(:decimal_value, '123.10')
      @field_value.decimal_value.should == 123.10
    end

    it 'converts the value to a float' do
      @field_value.set_attribute(:float_value, '123.10')
      @field_value.float_value.should.be.close(123.10, 0.01)
    end

    it 'converts the value to a date when given an integer' do
      @field_value.set_attribute(:date_value, 1411499145)
      @field_value.date_value.is_a?(NSDate).should == true
      @field_value.date_value.to_s.should.match /^2014-09-23/
    end

    it 'converts the value to a date when given a string' do
      @field_value.set_attribute(:date_value, '2014-12-04T21:06:43.793Z')
      @field_value.date_value.is_a?(NSDate).should == true
      @field_value.date_value.to_s.should.match /^2014-12-04/
    end

    it 'converts the value to a boolean when given a boolean' do
      @field_value.set_attribute(:boolean_value, true)
      @field_value.boolean_value.should == 1
    end

    it 'converts the value to a boolean when given a string' do
      @field_value.set_attribute(:boolean_value, 'true')
      @field_value.boolean_value.should == 1
      @field_value.set_attribute(:boolean_value, 'false')
      @field_value.boolean_value.should == 0
    end
  end
end
