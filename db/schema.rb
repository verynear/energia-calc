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

ActiveRecord::Schema.define(version: 20170817220746) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "apartment_monthly_data", force: :cascade do |t|
    t.integer  "wegowise_id",     null: false
    t.string   "data_type",       null: false
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "audit_report_id", null: false
  end

  create_table "apartments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "wegowise_id",          default: 0
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

  add_index "apartments", ["building_id"], name: "index_apartments_on_building_id", using: :btree
  add_index "apartments", ["wegowise_id"], name: "index_apartments_on_wegowise_id", using: :btree

  create_table "attachments", force: :cascade do |t|
    t.string   "title"
    t.text     "pdf_data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "audit_report_id"
  end

  create_table "audit_field_values", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "audit_field_id"
    t.uuid     "audit_structure_id"
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

  add_index "audit_field_values", ["audit_field_id"], name: "index_audit_field_values_on_audit_field_id", using: :btree
  add_index "audit_field_values", ["audit_structure_id"], name: "index_audit_field_values_on_audit_structure_id", using: :btree

  create_table "audit_fields", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
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

  add_index "audit_fields", ["api_name", "grouping_id"], name: "index_audit_fields_on_api_name_and_grouping_id", unique: true, using: :btree

  create_table "audit_reports", force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "name",               null: false
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "wegoaudit_id",       null: false
    t.text     "markdown"
    t.integer  "report_template_id"
    t.uuid     "organization_id"
    t.string   "wegoaudit_photo_id"
  end

  create_table "audit_strc_types", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
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

  add_index "audit_strc_types", ["api_name", "parent_structure_type_id"], name: "index_audit_strc_types_on_api_name_and_parent_structure_type_id", unique: true, using: :btree

  create_table "audit_structures", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "audit_strc_type_id"
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

  add_index "audit_structures", ["audit_strc_type_id"], name: "index_audit_structures_on_audit_strc_type_id", using: :btree
  add_index "audit_structures", ["physical_structure_type", "physical_structure_id"], name: "structure_physical_structure", using: :btree

  create_table "audit_types", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                      null: false
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "audits", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.boolean  "is_archived",          default: false
    t.datetime "performed_on",                         null: false
    t.uuid     "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.uuid     "audit_structure_id"
    t.uuid     "locked_by"
    t.uuid     "audit_type_id"
    t.datetime "destroy_attempt_on"
    t.uuid     "organization_id"
  end

  add_index "audits", ["user_id"], name: "index_audits_on_user_id", using: :btree

  create_table "building_monthly_data", force: :cascade do |t|
    t.integer  "wegowise_id",     null: false
    t.string   "data_type",       null: false
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "audit_report_id", null: false
    t.float    "yearly_data"
  end

  create_table "buildings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "wegowise_id",                   default: 0
    t.string   "street_address"
    t.string   "city"
    t.string   "state_code"
    t.string   "zip_code"
    t.integer  "development_id",                default: 0
    t.integer  "sqft"
    t.integer  "n_stories"
    t.string   "building_type"
    t.string   "construction"
    t.integer  "n_apartments",                  default: 0
    t.integer  "n_bedrooms",                    default: 0
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
    t.integer  "n_gas_general_meters",          default: 0,               null: false
    t.integer  "n_gas_area_meters",             default: 0,               null: false
    t.integer  "n_electric_general_meters",     default: 0,               null: false
    t.integer  "n_electric_area_meters",        default: 0,               null: false
    t.integer  "n_water_general_meters",        default: 0,               null: false
    t.integer  "n_water_area_meters",           default: 0,               null: false
    t.integer  "conditioned_sqft"
    t.boolean  "quarantine"
    t.integer  "n_oil_area_meters",             default: 0,               null: false
    t.integer  "n_oil_general_meters",          default: 0,               null: false
    t.float    "lat"
    t.float    "lng"
    t.boolean  "public_housing"
    t.string   "nickname",                                                null: false
    t.string   "country",                       default: "United States"
    t.string   "county"
    t.string   "climate_zone"
    t.integer  "water_area_meters_count",       default: 0,               null: false
    t.integer  "electric_area_meters_count",    default: 0,               null: false
    t.integer  "gas_area_meters_count",         default: 0,               null: false
    t.integer  "oil_area_meters_count",         default: 0,               null: false
    t.integer  "water_general_meters_count",    default: 0,               null: false
    t.integer  "electric_general_meters_count", default: 0,               null: false
    t.integer  "gas_general_meters_count",      default: 0,               null: false
    t.integer  "oil_general_meters_count",      default: 0,               null: false
    t.integer  "steam_general_meters_count",    default: 0,               null: false
    t.integer  "steam_area_meters_count",       default: 0,               null: false
    t.integer  "propane_general_meters_count",  default: 0,               null: false
    t.integer  "propane_area_meters_count",     default: 0,               null: false
    t.boolean  "tenant_pays_area_water"
    t.boolean  "tenant_pays_area_electric"
    t.boolean  "tenant_pays_area_gas"
    t.boolean  "tenant_pays_area_oil"
    t.boolean  "tenant_pays_area_steam"
    t.boolean  "tenant_pays_area_propane"
    t.integer  "solar_general_meters_count",    default: 0,               null: false
    t.integer  "solar_area_meters_count",       default: 0,               null: false
    t.integer  "apartments_count",              default: 0,               null: false
    t.integer  "areas_count",                   default: 0
    t.string   "other_building_type"
    t.string   "object_type"
    t.integer  "n_steam_general_meters",        default: 0,               null: false
    t.integer  "n_steam_area_meters",           default: 0,               null: false
    t.integer  "n_propane_general_meters",      default: 0,               null: false
    t.integer  "n_propane_area_meters",         default: 0,               null: false
    t.integer  "n_solar_general_meters",        default: 0,               null: false
    t.integer  "n_solar_area_meters",           default: 0,               null: false
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "cloned",                        default: true
    t.datetime "destroy_attempt_on"
  end

  add_index "buildings", ["wegowise_id"], name: "index_buildings_on_wegowise_id", using: :btree

  create_table "content_blocks", force: :cascade do |t|
    t.integer  "audit_report_id"
    t.string   "name"
    t.text     "markdown"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_enumerations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "audit_field_id"
    t.string   "value",                null: false
    t.integer  "display_order",        null: false
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "field_enumerations", ["audit_field_id"], name: "index_field_enumerations_on_audit_field_id", using: :btree

  create_table "field_values", force: :cascade do |t|
    t.string   "value",          default: "", null: false
    t.string   "field_api_name",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "parent_type"
  end

  add_index "field_values", ["parent_type", "parent_id"], name: "index_field_values_on_parent_type_and_parent_id", using: :btree

  create_table "fields", force: :cascade do |t|
    t.string "name",                             null: false
    t.string "api_name",                         null: false
    t.string "value_type",                       null: false
    t.string "level",      default: "structure"
    t.string "options",    default: [],                       array: true
  end

  add_index "fields", ["api_name"], name: "index_fields_on_api_name", unique: true, using: :btree

  create_table "groupings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "audit_strc_type_id"
    t.string   "name",                 null: false
    t.integer  "display_order",        null: false
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groupings", ["audit_strc_type_id"], name: "index_groupings_on_audit_strc_type_id", using: :btree

  create_table "hourly_temperatures", force: :cascade do |t|
    t.string  "location"
    t.string  "state_code"
    t.date    "date"
    t.integer "hour",        limit: 2
    t.float   "temperature"
  end

  add_index "hourly_temperatures", ["location", "date", "hour"], name: "index_hourly_temperatures_on_location_and_date_and_hour", unique: true, using: :btree

  create_table "measure_selections", force: :cascade do |t|
    t.integer  "audit_report_id",                   null: false
    t.integer  "measure_id",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.integer  "calculate_order"
    t.text     "description"
    t.boolean  "enabled",            default: true
    t.string   "wegoaudit_photo_id"
    t.string   "recommendation"
  end

  create_table "measures", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_name",   null: false
  end

  add_index "measures", ["api_name"], name: "index_measures_on_api_name", unique: true, using: :btree

  create_table "meters", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "wegowise_id",                 default: 0
    t.string   "data_type"
    t.string   "coverage"
    t.text     "notes"
    t.boolean  "for_heating"
    t.integer  "n_buildings",                 default: 0
    t.string   "scope"
    t.string   "other_utility_company"
    t.integer  "buildings_count",             default: 0
    t.integer  "utility_company_wegowise_id", default: 0
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

  add_index "meters", ["utility_company_wegowise_id"], name: "index_meters_on_utility_company_wegowise_id", using: :btree
  add_index "meters", ["wegowise_id"], name: "index_meters_on_wegowise_id", using: :btree

  create_table "organization_buildings", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "organization_id"
    t.uuid     "building_id"
    t.boolean  "active",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organization_buildings", ["building_id"], name: "index_organization_buildings_on_building_id", using: :btree
  add_index "organization_buildings", ["organization_id"], name: "index_organization_buildings_on_organization_id", using: :btree

  create_table "organizations", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.uuid     "owner_id"
    t.integer  "wegowise_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["owner_id"], name: "index_organizations_on_owner_id", using: :btree
  add_index "organizations", ["wegowise_id"], name: "index_organizations_on_wegowise_id", using: :btree

  create_table "original_structure_field_values", force: :cascade do |t|
    t.integer "audit_report_id"
    t.string  "structure_wegoaudit_id"
    t.string  "value"
    t.string  "field_api_name"
  end

  add_index "original_structure_field_values", ["structure_wegoaudit_id", "field_api_name", "audit_report_id"], name: "original_structure_field_values_unique_index", unique: true, using: :btree

  create_table "report_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "markdown"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout",          null: false
    t.uuid     "organization_id"
  end

  create_table "sample_groups", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "parent_structure_id",  null: false
    t.uuid     "audit_strc_type_id",   null: false
    t.string   "name",                 null: false
    t.integer  "n_structures"
    t.datetime "successful_upload_on"
    t.datetime "upload_attempt_on"
    t.datetime "full_download_on"
    t.datetime "destroy_attempt_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sample_groups", ["parent_structure_id"], name: "index_sample_groups_on_parent_structure_id", using: :btree

  create_table "structure_changes", force: :cascade do |t|
    t.uuid     "structure_wegoaudit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "structure_type_id"
    t.integer  "measure_selection_id",   null: false
  end

  create_table "structure_images", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.string   "file_name",            null: false
    t.string   "photo_path"
    t.uuid     "audit_structure_id",   null: false
    t.datetime "upload_attempt_on"
    t.datetime "successful_upload_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "destroy_attempt_on"
    t.boolean  "asset_processing"
    t.text     "image_data"
  end

  add_index "structure_images", ["audit_structure_id"], name: "index_structure_images_on_audit_structure_id", using: :btree

  create_table "structure_types", force: :cascade do |t|
    t.string "name",            null: false
    t.string "api_name",        null: false
    t.string "parent_api_name"
    t.string "genus_api_name",  null: false
  end

  add_index "structure_types", ["api_name"], name: "index_structure_types_on_api_name", unique: true, using: :btree

  create_table "structures", force: :cascade do |t|
    t.string   "name"
    t.boolean  "proposed"
    t.integer  "structure_change_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "substructure_types", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "parent_structure_type_id"
    t.uuid     "audit_strc_type_id"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temperature_locations", force: :cascade do |t|
    t.string "state_code", null: false
    t.string "location",   null: false
  end

  add_index "temperature_locations", ["location", "state_code"], name: "index_temperature_locations_on_location_and_state_code", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username"
    t.string   "provider",               default: "wegowise"
    t.integer  "wegowise_id",            default: 1234
    t.string   "token"
    t.string   "secret"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organization",           default: "Elevate Energy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "email"
    t.uuid     "organization_id"
    t.string   "encrypted_password",     default: "",               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,                null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "role",                   default: "user"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "apartment_monthly_data", "audit_reports", on_delete: :cascade
  add_foreign_key "audit_reports", "users"
  add_foreign_key "audits", "audit_types"
  add_foreign_key "audits", "users", column: "locked_by"
  add_foreign_key "building_monthly_data", "audit_reports", on_delete: :cascade
  add_foreign_key "measure_selections", "audit_reports", on_delete: :cascade
  add_foreign_key "measure_selections", "measures", on_delete: :cascade
  add_foreign_key "original_structure_field_values", "audit_reports", on_delete: :cascade
  add_foreign_key "structure_changes", "measure_selections", on_delete: :cascade
  add_foreign_key "structures", "structure_changes", on_delete: :cascade
end
