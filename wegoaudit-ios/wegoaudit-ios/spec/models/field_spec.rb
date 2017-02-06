describe 'Field' do
  before do
    cdq.setup
    @id = NSUUID.UUID.UUIDString
    @field_params = { name: 'name', id: @id  }
  end

  after do
    cdq.reset!
  end

  describe '.form' do
    it 'should return the correct form for string types' do
      field = Field.new(@field_params.merge(value_type: 'string'))
      field.form.should == { title: 'name',
                             placeholder: '',
                             input_accessory: :done,
                             key: @id,
                             type: 'string' }
    end

    it 'should return the correct form for email types' do
      field = Field.new(@field_params.merge(value_type: 'email'))
      field.form.should == { title: 'name',
                             placeholder: 'test@example.com',
                             input_accessory: :done,
                             key: @id,
                             type: 'email' }
    end

    it 'should return the correct form for phone types' do
      field = Field.new(@field_params.merge(value_type: 'phone'))
      field.form.should == { title: 'name',
                             placeholder: '123-456-7890',
                             input_accessory: :done,
                             key: @id,
                             type: 'phone' }
    end

    it 'returns the correct form for text fields' do
      field = Field.new(@field_params.merge(value_type: 'text'))
      field.form.should == { title: 'name',
                             placeholder: '',
                             input_accessory: :done,
                             row_height: 100,
                             key: @id,
                             type: 'text' }
    end

    it 'should return the correct form for float types' do
      field = Field.new(@field_params.merge(value_type: 'float'))
      field.form.should == { title: 'name',
                             placeholder: '1.23456',
                             input_accessory: :done,
                             key: @id,
                             type: 'number' }
    end

    it 'should return the correct form for decimal types' do
      field = Field.new(@field_params.merge(value_type: 'decimal'))
      field.form.should == { title: 'name',
                             placeholder: '1.23456',
                             input_accessory: :done,
                             key: @id,
                             type: 'number' }
    end

    it 'should return the correct form for currency types' do
      field = Field.new(@field_params.merge(value_type: 'currency'))
      field.form.should == { title: 'name',
                             placeholder: '12.51',
                             input_accessory: :done,
                             key: @id,
                             type: 'number' }
    end

    it 'should return the correct form for integer types' do
      field = Field.new(@field_params.merge(value_type: 'integer'))
      field.form.should == { title: 'name',
                             placeholder: '234',
                             input_accessory: :done,
                             key: @id,
                             type: 'number' }
    end

    it 'should include items for picker types' do
      field = Field.new(@field_params.merge(value_type: 'picker'))
      FieldEnumeration.new(field_id: @id, value: 'value 1', display_order: 1)
      FieldEnumeration.new(field_id: @id, value: 'value 3', display_order: 3)
      FieldEnumeration.new(field_id: @id, value: 'value 4', display_order: 4)
      FieldEnumeration.new(field_id: @id, value: 'value 2', display_order: 2)

      field.form.should == { title: 'name',
                             placeholder: nil,
                             input_accessory: :done,
                             key: @id,
                             type: 'picker',
                             items: ['value 1', 'value 2', 'value 3', 'value 4']
                           }
    end
  end

  describe '.picker?' do
    it 'returns true if the type is picker' do
      field = Field.new(@field_params.merge(value_type: 'picker'))
      field.picker?.should == true
    end

    it 'returns false if the type is not a picker' do
      field = Field.new(@field_params.merge(value_type: 'string'))
      field.picker?.should == false
    end
  end

  describe '.storage_type' do
    it 'returns string_value for Field::STRING_TYPES' do
      Field::STRING_TYPES.each do |type|
        field = Field.new(@field_params.merge(value_type: type))
        field.storage_type.should == 'string_value'
      end
    end

    it 'returns "float_value" for float types' do
      Field::FLOAT_TYPES.each do |type|
        field = Field.new(@field_params.merge(value_type: type))
        field.storage_type.should == 'float_value'
      end
    end

    it 'returns "decimal_value" for decimal types' do
      Field::DECIMAL_TYPES.each do |type|
        field = Field.new(@field_params.merge(value_type: type))
        field.storage_type.should == 'decimal_value'
      end
    end

    it 'returns "integer_value" for integer types' do
      Field::INTEGER_TYPES.each do |type|
        field = Field.new(@field_params.merge(value_type: type))
        field.storage_type.should == 'integer_value'
      end
    end

    it 'returns "date_value" for type date' do
      field = Field.new(@field_params.merge(value_type: 'date'))
      field.storage_type.should == 'date_value'
    end

    it 'returns "boolean_value" for type swtich' do
      field = Field.new(@field_params.merge(value_type: 'switch'))
      field.storage_type.should == 'boolean_value'
    end
  end

  describe '.enumeration_values' do
    it 'returns nil for none picker types' do
      field = Field.new(@field_params.merge(value_type: 'switch'))
      field.enumeration_values.should == nil
    end

    it 'returns enumeration values sorted by display order for picker types' do
      field = Field.new(@field_params.merge(value_type: 'picker'))
      FieldEnumeration.new(field_id: @id, value: 'value 1', display_order: 1)
      FieldEnumeration.new(field_id: @id, value: 'value 3', display_order: 3)
      FieldEnumeration.new(field_id: @id, value: 'value 4', display_order: 4)
      FieldEnumeration.new(field_id: @id, value: 'value 2', display_order: 2)
      field.enumeration_values
        .should == ['value 1', 'value 2', 'value 3', 'value 4']
    end
  end
end
