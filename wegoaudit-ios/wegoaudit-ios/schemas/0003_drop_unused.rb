# v0003
#
# Drop several entities and columns from the schema that are not used anywhere.
#
schema "0003 drop_unused" do
  entity 'User' do
    string :id, optional: false
    integer32 :wegowise_id
    string :username, optional: false
    string :first_name, optional: false
    string :last_name, optional: false
    string :auth_token
    datetime :last_logged_in
    datetime :created_at
    datetime :updated_at
  end

  entity 'Audit' do
    string :id, optional: false
    string :name, optional: false
    string :user_id
    string :locked_by
    string :structure_id
    boolean :is_archived, default: false
    string :audit_type_id
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :performed_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'Structure' do
    string :id, optional: false
    string :structure_type_id
    string :parent_structure_id
    string :sample_group_id
    string :name, optional: false
    string :physical_structure_id
    string :physical_structure_type
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :full_download_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'SampleGroup' do
    string :id, optional: false
    string :structure_type_id
    string :parent_structure_id
    string :name, optional: false
    integer32 :n_structures
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :full_download_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'StructureType' do
    string :id
    string :parent_structure_type_id
    string :name, optional: false
    boolean :active, default: true
    boolean :primary, default: false
    integer32 :display_order
    string :physical_structure_type
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'Grouping' do
    string :id
    string :structure_type_id
    string :name
    integer32 :display_order
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
  end

  entity 'Field' do
    string :id
    string :name
    string :placeholder
    string :value_type
    integer32 :display_order
    string :grouping_id
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
  end

  entity 'FieldValue' do
    string :id
    string :field_id
    string :structure_id
    string :string_value
    float :float_value
    decimal :decimal_value
    integer32 :integer_value
    datetime :date_value
    boolean :boolean_value
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'FieldEnumeration' do
    string :id
    string :field_id
    string :value
    integer32 :display_order
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
  end

  entity 'Building' do
    string :id
    integer32  :wegowise_id
    string   :street_address
    string   :city
    string   :state_code
    string   :zip_code
    integer32  :development_id
    integer32  :sqft
    integer32  :n_stories
    string   :building_type
    string   :construction
    integer32  :n_apartments
    integer32  :n_bedrooms
    string   :heating_fuel
    string   :hot_water_fuel
    string   :hot_water_system
    integer32  :n_elevators
    string   :heating_system
    string   :dryer_fuel
    string   :cooling_system
    boolean  :draft
    string     :notes
    boolean  :green_certified
    boolean  :leed_certified
    boolean  :epa_certified
    boolean  :nahb_certified
    boolean  :other_certified
    string   :leed_level
    boolean  :has_laundry
    boolean  :has_pool
    boolean  :pool_year_round
    string   :pool_fuel
    integer32  :year_built
    boolean  :low_income
    string   :resident_type
    integer32  :apartment_sqft
    boolean  :has_basement
    integer32  :basement_sqft
    boolean  :basement_conditioned
    integer32  :n_gas_general_meters
    integer32  :n_gas_area_meters
    integer32  :n_electric_general_meters
    integer32  :n_electric_area_meters
    integer32  :n_water_general_meters
    integer32  :n_water_area_meters
    integer32  :conditioned_sqft
    boolean  :quarantine
    integer32  :n_oil_area_meters
    integer32  :n_oil_general_meters
    float    :lat
    float    :lng
    boolean  :public_housing
    string   :nickname
    string   :country
    string   :county
    string   :climate_zone
    integer32  :water_area_meters_count
    integer32  :electric_area_meters_count
    integer32  :gas_area_meters_count
    integer32  :oil_area_meters_count
    integer32  :water_general_meters_count
    integer32  :electric_general_meters_count
    integer32  :gas_general_meters_count
    integer32  :oil_general_meters_count
    integer32  :steam_general_meters_count
    integer32  :steam_area_meters_count
    integer32  :propane_general_meters_count
    integer32  :propane_area_meters_count
    boolean  :tenant_pays_area_water
    boolean  :tenant_pays_area_electric
    boolean  :tenant_pays_area_gas
    boolean  :tenant_pays_area_oil
    boolean  :tenant_pays_area_steam
    boolean  :tenant_pays_area_propane
    integer32  :solar_general_meters_count
    integer32  :solar_area_meters_count
    integer32  :apartments_count
    integer32  :areas_count
    string   :other_building_type
    string   :object_type
    integer32  :n_steam_general_meters
    integer32  :n_steam_area_meters
    integer32  :n_propane_general_meters
    integer32  :n_propane_area_meters
    integer32  :n_solar_general_meters
    integer32  :n_solar_area_meters
    datetime :successful_upload_on
    datetime :upload_attempt_on
    boolean :cloned, default: true
    datetime :destroy_attempt_on

    datetime :created_at
    datetime :updated_at
  end

  entity 'Apartment' do
    string :id
    string :building_id
    integer32 :wegowise_id
    string :unit_number
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    integer32  :sqft
    integer32  :n_bedrooms
    boolean :cloned, default: true
    datetime :destroy_attempt_on
  end

  entity 'StructureImage' do
    string :id
    string :structure_id
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end

  entity 'Meter' do
    string :id
    integer32  :wegowise_id
    string   :data_type
    string   :coverage
    string     :notes
    boolean  :for_heating
    integer32  :n_buildings
    string   :scope
    string   :other_utility_company
    integer32  :buildings_count
    integer32  :utility_company_wegowise_id
    string   :utility_company_name
    boolean  :tenant_pays
    string   :status
    string   :account_number
    string   :importer_version
    datetime :attempted_import_at
    datetime :status_changed_at
    datetime :successful_import_at
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    boolean  :cloned, default: true
    datetime :destroy_attempt_on
  end

  entity 'AuditType' do
    string :id
    string :name,       null: false
    boolean :active,     default: true
    datetime :created_at
    datetime :updated_at
  end

  entity 'Measure' do
    string :id
    string :name
    datetime :created_at
    datetime :updated_at
    boolean  :active, default: true
  end

  entity 'MeasureValue' do
    string :id
    string :measure_id
    string :audit_id
    boolean :value, default: false
    string :notes
    datetime :successful_upload_on
    datetime :upload_attempt_on
    datetime :created_at
    datetime :updated_at
    datetime :destroy_attempt_on
  end
end
