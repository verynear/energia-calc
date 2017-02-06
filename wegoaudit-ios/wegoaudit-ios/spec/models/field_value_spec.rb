describe 'FieldValue' do
  before do
    cdq.setup
    @field = Field.create_with_uuid(name: 'Name')
    @field_value = FieldValue.new(field_id: @field.id)
  end

  after do
    cdq.reset!
  end

  describe 'value=' do
    it 'for field.type="text" converts the value to a string' do
      @field.value_type = 'text'
      @field_value.value = :foo
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="string" converts the value to a string' do
      @field.value_type = 'string'
      @val = :foo
      @field_value.value = :foo
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="phone" converts the value to a string' do
      @field.value_type = 'phone'
      @val = :foo
      @field_value.value = :foo
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="email" converts the value to a string' do
      @field.value_type = 'email'
      @field_value.value = :foo
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="picker" converts the value to a string' do
      @field.value_type = 'picker'
      @field_value.value = :foo
      @field_value.string_value.should == 'foo'
    end

    it 'for field.type="integer" converts the value to an integer' do
      @field.value_type = 'integer'
      @field_value.value = 123.10
      @field_value.integer_value.should == 123
    end

    it 'for field.type="currency" converts the value to a decimal' do
      @field.value_type = 'currency'
      @field_value.value = 123.10
      @field_value.decimal_value.should == 123.10
    end

    it 'for field.type="float" converts the value to a float' do
      @field.value_type = 'float'
      @field_value.value = 123.10
      @field_value.float_value.should.be.close(123.10, 0.01)
    end

    it 'for field.type="date" converts the value to a date' do
      @field.value_type = 'date'
      @field_value.value = 1411499145
      @field_value.date_value.is_a?(NSDate).should == true
      @field_value.date_value.to_s.should.match /^2014-09-23/
    end

    it 'for field.type="switch" converts the value to a boolean' do
      @field.value_type = 'switch'
      @field_value.value = true
      @field_value.boolean_value.should == 1
    end
  end

  describe '.value' do
    it 'returns the string_value for Field::STRING_TYPES' do
      @field_value.string_value = 'foo'
      Field::STRING_TYPES.each do |type|
        @field.value_type = type
        @field_value.value.should == 'foo'
      end
    end

    it 'returns the decimal_value for decimal' do
      @field_value.decimal_value = 1234.51
      @field.value_type = 'decimal'
      @field_value.value.should == 1234.51
    end

    it 'returns the decimal_value for currency' do
      @field_value.decimal_value = 1234.51
      @field.value_type = 'currency'
      @field_value.value.should == 1234.51
    end

    it 'returns the integer_value for integers' do
      @field_value.integer_value = 1234
      @field.value_type = 'integer'
      @field_value.value.should == 1234
    end

    it 'returns the float_value for floats' do
      @field_value.float_value = 1234.1234
      @field.value_type = 'float'
      @field_value.value.should.be.close(1234.1234, 0.01)
    end

    it 'returns the date_value for dates' do
      now = Time.now
      @field_value.date_value = now
      @field.value_type = 'date'
      @field_value.value.should == now.to_i
    end

    it 'returns the boolean_value for switch' do
      @field_value.boolean_value = false
      @field.value_type = 'switch'
      @field_value.value.should == 0
    end
  end

  describe '.clone' do
    it 'copies all of the fields' do
      @field.value_type = 'text'
      @field_value.value = :foo
      klone = @field_value.clone
      klone.field.should == @field
      klone.string_value.should == 'foo'
    end

    it 'creates a new id' do
      @field.value_type = 'text'
      @field_value.value = :foo
      klone = @field_value.clone
      klone.id.should != nil
      klone.id.should != @field_value.id
    end

    it 'does not copy excluded fields' do
      @field_value.successful_upload_on = Time.now
      @field_value.upload_attempt_on = Time.now
      @field_value.created_at = Time.now
      @field_value.updated_at = Time.now

      klone = @field_value.clone
      klone.successful_upload_on.should == nil
      klone.upload_attempt_on.should == nil
      klone.created_at.should == nil
      klone.updated_at.should == nil
    end

    it 'merges in any additional attributes' do
      @field.value_type = 'text'
      @field_value.value = :foo
      klone = @field_value.clone('string_value' => 'bar')
      klone.value.should == 'bar'
    end
  end
end
