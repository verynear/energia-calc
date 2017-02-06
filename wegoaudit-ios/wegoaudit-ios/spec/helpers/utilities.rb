def delete_cookies
  storage = NSHTTPCookieStorage.sharedHTTPCookieStorage
  storage.cookies.each do |cookie|
    storage.deleteCookie(cookie)
  end
  NSUserDefaults.standardUserDefaults.synchronize
end

def create_audits(number = 20)
  user = find_or_create_user
  (0...number).each do |n|
    now = get_time(2014, 9, (n%2)+1, n, 0)
    locked_by = (n < number/4) ? user.id : nil
    archived = (n < number/2) ? true : false
    audit = Audit.create(
      'id' => get_uuid,
      'name' => "Audit (#{n})",
      'user_id' => user.id,
      'is_archived' => archived,
      'locked_by' => locked_by,
      'performed_on' => now)
  end
  cdq.save
end

def find_or_create_user
  @user = User.create(valid_user_params)
end

def valid_user_params
  now = get_time
  { 'id' => get_uuid,
    'wegowise_id' => 2,
    'username' => 'smitty',
    'first_name' => 'Joseph',
    'last_name' => 'Smith',
    'created_at' => now,
    'updated_at' => now }
end

def get_time(*args)
  if args.length > 0
    Time.mktime(*args)
  else
    Time.mktime('2014', '09', '02')
  end
end

def mock_expectation
  1.should == 1
end

def create_audit_with_details
  audit_type = StructureType.create_with_uuid(name: 'Audit', primary: 1)
  grouping1 = Grouping.create_with_uuid(name: 'All Types', structure_type_id: audit_type.id, display_order: 1)
  count = 0
  types = Field::STRING_TYPES + Field::FLOAT_TYPES + Field::DECIMAL_TYPES + Field::INTEGER_TYPES + ['date', 'switch']
  types.each do |ftype|
    h = { name: ftype.upcase, value_type: ftype, placeholder: ftype }
    Field.create_with_uuid(h.merge(grouping_id: grouping1.id, display_order: count))
    count += 1
  end
  @structure = Structure.create_with_uuid(name: 'Audit', structure_type_id: audit_type.id)
  @audit = Audit.create_with_uuid('name' => 'Audit 1',
                                  'structure_id' => @structure.id,
                                  'is_archived' => false)
end

def get_uuid
  NSUUID.UUID.UUIDString
end

def full_building_params
  { 'id' => 'building_structure',
    'structure_type_id' => '3cb11ab4-6247-4f43-8df6-762488819c8f',
    'name' => '10 Greene Street',
    'successful_upload_on' => '2014-12-04T21:06:43.793Z',
    'upload_attempt_on' => '2014-12-04T21:06:43.793Z',
    'created_at' => '2014-12-04T21:06:43.793Z',
    'updated_at' => '2014-12-04T21:06:43.793Z',
    'parent_structure_id' => nil,
    'physical_structure_id' => 'building_object',
    'physical_structure_type' => 'Building',
    'physical_structure' => { 'id' => 'building_object',
                              'conditioned_sqft' => 937,
                              'wegowise_id' => 34174,
                              'nickname' => '10 Greene Street',
                              'n_stories' => 1,
                              'n_apartments' => 1,
                              'sqft' => 937,
                              'year_built' => 1942,
                              'notes' => '',
                              'type' => 'sf_detached',
                              'basement_sqft' => 900,
                              'basement_conditioned' => false,
                              'cooling_system' => 'window_ac',
                              'heating_fuel' => 'Oil',
                              'heating_system' => 'hot_water_boiler',
                              'hot_water_fuel' => 'Gas',
                              'hot_water_system' => 'indirect_with_heat',
                              'city' => 'Troy',
                              'climate_zone' => nil,
                              'country' => 'United States',
                              'county' => 'Rensselaer County',
                              'state' => 'NY',
                              'street_address' => '10 Greene Street',
                              'zip_code' => '12180',
                              'created_at' => '2014-12-04T21:06:43.793Z',
                              'updated_at' => '2014-12-04T21:06:43.793Z',
                              'cloned' => true },
    'substructures' => [
      { 'id' => 'meter_structure',
        'structure_type_id' => '8e80e909-ec90-4db6-b76e-df92d29bba3e',
        'name' => 'a1234',
        'successful_upload_on' => '2014-12-04T21:06:43.793Z',
        'upload_attempt_on' => '2014-12-04T21:06:43.793Z',
        'created_at' => '2014-12-04T21:06:43.793Z',
        'updated_at' => '2014-12-04T21:06:43.793Z',
        'parent_structure_id' => 'a27f77a4-8d5c-4bfb-925f-1cba63085896',
        'physical_structure_id' => 'meter_object',
        'physical_structure_type' => 'Meter',
        'physical_structure' => {
          'id' => 'meter_object',
          'wegowise_id'=>1,
          'data_type' => 'Gas',
          'scope' => 'BuildingMeter',
          'account_number' => 'a1234',
          'created_at' => '2014-12-04T21:06:43.793Z',
          'updated_at' => '2014-12-04T21:06:43.793Z',
          'cloned' => true
         }
      },
      { 'id' => 'apartment_structure',
        'structure_type_id' => 'a05a5986-1761-4f39-ba2a-4f6e0593ffe3',
        'name' => '101a',
        'successful_upload_on' => '2014-12-04T21:06:43.793Z',
        'upload_attempt_on' => '2014-12-04T21:06:43.793Z',
        'created_at' => '2014-12-04T21:06:43.793Z',
        'updated_at' => '2014-12-04T21:06:43.793Z',
        'parent_structure_id' => 'a27f77a4-8d5c-4bfb-925f-1cba63085896',
        'physical_structure_id' => 'apartment_object',
        'physical_structure_type' => 'Apartment',
        'physical_structure' => {
          'id' => 'apartment_object',
          'wegowise_id' => 1,
          'building_id' => '3975016c-a6f5-431c-b7f1-9bb9cacadf6f',
          'unit_number' => '101a',
          'sqft' => 1000,
          'n_bedrooms' => 2,
          'created_at' => '2014-12-04T21:06:43.793Z',
          'updated_at' => '2014-12-04T21:06:43.793Z',
          'cloned' => true
        }
      }
    ],
    'field_values' => [
      { 'id' => 'string_field_value',
        'field_id' => 'string_field',
        'structure_id' => 'building_structure',
        'string_value' => 'string_value',
        'created_at' => '2014-12-04T21:06:43.793Z',
        'updated_at' => '2014-12-04T21:06:43.793Z' },
      { 'id' => 'date_field_value',
        'field_id' => 'date_field',
        'structure_id' => 'building_structure',
        'date_value' => '2014-11-15T21:06:43.793Z',
        'created_at' => '2014-12-04T21:06:43.793Z',
        'updated_at' => '2014-12-04T21:06:43.793Z' }
    ]
  }
end
