# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151215170700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "apartments", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "wegowise_id"
    t.uuid     "building_id"
    t.string   "unit_number"
    t.integer  "sqft"
    t.integer  "n_bedrooms"
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cloned",               default: true
    t.datetime "destroy_attempt_on"
  end

  create_table "audit_types", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",                      null: false
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",                                 null: false
    t.boolean  "is_archived",          default: false
    t.datetime "performed_on",                         null: false
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.uuid     "structure_id"
    t.uuid     "locked_by"
    t.uuid     "audit_type_id"
    t.datetime "destroy_attempt_on"
  end

  create_table "buildings", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "wegowise_id"
    t.string   "street_address"
    t.string   "city"
    t.string   "state_code"
    t.string   "zip_code"
    t.integer  "development_id"
    t.integer  "sqft"
    t.integer  "n_stories"
    t.string   "building_type"
    t.string   "construction"
    t.integer  "n_apartments"
    t.integer  "n_bedrooms"
    t.string   "heating_fuel"
    t.string   "hot_water_fuel"
    t.string   "hot_water_system"
    t.integer  "n_elevators"
    t.string   "heating_system"
    t.string   "dryer_fuel"
    t.string   "cooling_system"
    t.boolean  "draft",                         default: true
    t.text     "notes"
    t.boolean  "green_certified"
    t.boolean  "leed_certified"
    t.boolean  "epa_certified"
    t.boolean  "nahb_certified"
    t.boolean  "other_certified"
    t.string   "leed_level"
    t.boolean  "has_laundry"
    t.boolean  "has_pool"
    t.boolean  "pool_year_round"
    t.string   "pool_fuel"
    t.integer  "year_built"
    t.boolean  "low_income"
    t.string   "resident_type"
    t.integer  "apartment_sqft"
    t.boolean  "has_basement"
    t.integer  "basement_sqft"
    t.boolean  "basement_conditioned"
    t.integer  "n_gas_general_meters",          default: 0,    null: false
    t.integer  "n_gas_area_meters",             default: 0,    null: false
    t.integer  "n_electric_general_meters",     default: 0,    null: false
    t.integer  "n_electric_area_meters",        default: 0,    null: false
    t.integer  "n_water_general_meters",        default: 0,    null: false
    t.integer  "n_water_area_meters",           default: 0,    null: false
    t.integer  "conditioned_sqft"
    t.boolean  "quarantine"
    t.integer  "n_oil_area_meters",             default: 0,    null: false
    t.integer  "n_oil_general_meters",          default: 0,    null: false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "public_housing"
    t.string   "nickname",                                     null: false
    t.string   "country"
    t.string   "county"
    t.string   "climate_zone"
    t.integer  "water_area_meters_count",       default: 0,    null: false
    t.integer  "electric_area_meters_count",    default: 0,    null: false
    t.integer  "gas_area_meters_count",         default: 0,    null: false
    t.integer  "oil_area_meters_count",         default: 0,    null: false
    t.integer  "water_general_meters_count",    default: 0,    null: false
    t.integer  "electric_general_meters_count", default: 0,    null: false
    t.integer  "gas_general_meters_count",      default: 0,    null: false
    t.integer  "oil_general_meters_count",      default: 0,    null: false
    t.integer  "steam_general_meters_count",    default: 0,    null: false
    t.integer  "steam_area_meters_count",       default: 0,    null: false
    t.integer  "propane_general_meters_count",  default: 0,    null: false
    t.integer  "propane_area_meters_count",     default: 0,    null: false
    t.boolean  "tenant_pays_area_water"
    t.boolean  "tenant_pays_area_electric"
    t.boolean  "tenant_pays_area_gas"
    t.boolean  "tenant_pays_area_oil"
    t.boolean  "tenant_pays_area_steam"
    t.boolean  "tenant_pays_area_propane"
    t.integer  "solar_general_meters_count",    default: 0,    null: false
    t.integer  "solar_area_meters_count",       default: 0,    null: false
    t.integer  "apartments_count",              default: 0,    null: false
    t.integer  "areas_count",                   default: 0
    t.string   "other_building_type"
    t.string   "object_type"
    t.integer  "n_steam_general_meters",        default: 0,    null: false
    t.integer  "n_steam_area_meters",           default: 0,    null: false
    t.integer  "n_propane_general_meters",      default: 0,    null: false
    t.integer  "n_propane_area_meters",         default: 0,    null: false
    t.integer  "n_solar_general_meters",        default: 0,    null: false
    t.integer  "n_solar_area_meters",           default: 0,    null: false
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cloned",                        default: true
    t.datetime "destroy_attempt_on"
  end

  create_table "field_enumerations", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "field_id"
    t.string   "value",                null: false
    t.integer  "display_order",        null: false
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_values", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "field_id"
    t.uuid     "structure_id"
    t.text     "string_value"
    t.float    "float_value"
    t.decimal  "decimal_value"
    t.integer  "integer_value"
    t.datetime "date_value"
    t.boolean  "boolean_value"
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "destroy_attempt_on"
  end

  create_table "fields", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",                 null: false
    t.string   "placeholder"
    t.string   "value_type",           null: false
    t.integer  "display_order",        null: false
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.uuid     "grouping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_name",             null: false
  end

  add_index "fields", ["api_name", "grouping_id"], name: "index_fields_on_api_name_and_grouping_id", unique: true, using: :btree

  create_table "groupings", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "structure_type_id"
    t.string   "name",                 null: false
    t.integer  "display_order",        null: false
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measure_values", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "measure_id",                           null: false
    t.uuid     "audit_id",                             null: false
    t.boolean  "value",                default: false
    t.text     "notes"
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "destroy_attempt_on"
  end

  create_table "measures", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_name",                  null: false
  end

  add_index "measures", ["api_name"], name: "index_measures_on_api_name", unique: true, using: :btree

  create_table "memberships", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "organization_id"
    t.uuid     "user_id"
    t.string   "role"
    t.string   "access"
    t.integer  "wegowise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meters", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "wegowise_id"
    t.string   "data_type"
    t.string   "coverage"
    t.text     "notes"
    t.boolean  "for_heating"
    t.integer  "n_buildings"
    t.string   "scope"
    t.string   "other_utility_company"
    t.integer  "buildings_count"
    t.integer  "utility_company_wegowise_id"
    t.string   "utility_company_name"
    t.boolean  "tenant_pays"
    t.string   "status"
    t.string   "account_number"
    t.string   "importer_version"
    t.datetime "attempted_import_at"
    t.datetime "status_changed_at"
    t.datetime "successful_import_at"
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cloned",                      default: true
    t.datetime "destroy_attempt_on"
  end

  create_table "organization_buildings", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "organization_id"
    t.uuid     "building_id"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name"
    t.uuid     "owner_id"
    t.integer  "wegowise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sample_groups", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "parent_structure_id",  null: false
    t.uuid     "structure_type_id",    null: false
    t.string   "name",                 null: false
    t.integer  "n_structures"
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "full_download_on"
    t.datetime "destroy_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "structure_images", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "file_name",            null: false
    t.string   "s3_path"
    t.uuid     "structure_id",         null: false
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "destroy_attempt_on"
    t.boolean  "asset_processing"
  end

  create_table "structure_types", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "parent_structure_type_id"
    t.string   "name"
    t.boolean  "active"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "primary",                  default: false
    t.string   "physical_structure_type"
    t.string   "api_name",                                 null: false
  end

  add_index "structure_types", ["api_name", "parent_structure_type_id"], name: "index_structure_types_on_api_name_and_parent_structure_type_id", unique: true, using: :btree

  create_table "structures", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "structure_type_id"
    t.string   "name"
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "parent_structure_id"
    t.uuid     "physical_structure_id"
    t.string   "physical_structure_type"
    t.datetime "full_download_on"
    t.datetime "destroy_attempt_on"
    t.uuid     "sample_group_id"
  end

  add_index "structures", ["physical_structure_type", "physical_structure_id"], name: "structure_physical_structure", using: :btree

  create_table "substructure_types", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "parent_structure_type_id"
    t.uuid     "structure_type_id"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "username"
    t.string   "provider"
    t.integer  "wegowise_id"
    t.string   "token"
    t.string   "secret"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "audits", "audit_types", name: "audits_audit_type_id_fk"
  add_foreign_key "audits", "users", name: "audits_locked_by_fk", column: "locked_by"

end
