class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings, id: :uuid do |t|
      t.integer  :wegowise_id, index: true
      t.string   :street_address,                                      null: false
      t.string   :city,                                                null: false
      t.string   :state_code,                    limit: 2,             null: false
      t.string   :zip_code,                                            null: false
      t.integer  :development_id
      t.integer  :sqft
      t.integer  :n_stories
      t.string   :building_type
      t.string   :construction
      t.integer  :n_apartments
      t.integer  :n_bedrooms
      t.string   :heating_fuel
      t.string   :hot_water_fuel
      t.string   :hot_water_system
      t.integer  :n_elevators
      t.string   :heating_system
      t.string   :dryer_fuel
      t.string   :cooling_system
      t.boolean  :draft,                                               null: false
      t.text     :notes
      t.boolean  :green_certified
      t.boolean  :leed_certified
      t.boolean  :epa_certified
      t.boolean  :nahb_certified
      t.boolean  :other_certified
      t.string   :leed_level
      t.boolean  :has_laundry
      t.boolean  :has_pool
      t.boolean  :pool_year_round
      t.string   :pool_fuel
      t.integer  :year_built
      t.boolean  :low_income
      t.string   :resident_type
      t.integer  :apartment_sqft
      t.boolean  :has_basement
      t.integer  :basement_sqft
      t.boolean  :basement_conditioned
      t.integer  :n_gas_general_meters,                    default: 0, null: false
      t.integer  :n_gas_area_meters,                       default: 0, null: false
      t.integer  :n_electric_general_meters,               default: 0, null: false
      t.integer  :n_electric_area_meters,                  default: 0, null: false
      t.integer  :n_water_general_meters,                  default: 0, null: false
      t.integer  :n_water_area_meters,                     default: 0, null: false
      t.integer  :conditioned_sqft
      t.boolean  :quarantine
      t.integer  :n_oil_area_meters,                       default: 0, null: false
      t.integer  :n_oil_general_meters,                    default: 0, null: false
      t.float    :lat
      t.float    :lng
      t.boolean  :public_housing
      t.string   :nickname,                                            null: false
      t.string   :country
      t.string   :county
      t.string   :climate_zone
      t.integer  :water_area_meters_count,                 default: 0, null: false
      t.integer  :electric_area_meters_count,              default: 0, null: false
      t.integer  :gas_area_meters_count,                   default: 0, null: false
      t.integer  :oil_area_meters_count,                   default: 0, null: false
      t.integer  :water_general_meters_count,              default: 0, null: false
      t.integer  :electric_general_meters_count,           default: 0, null: false
      t.integer  :gas_general_meters_count,                default: 0, null: false
      t.integer  :oil_general_meters_count,                default: 0, null: false
      t.integer  :steam_general_meters_count,              default: 0, null: false
      t.integer  :steam_area_meters_count,                 default: 0, null: false
      t.integer  :propane_general_meters_count,            default: 0, null: false
      t.integer  :propane_area_meters_count,               default: 0, null: false
      t.boolean  :tenant_pays_area_water
      t.boolean  :tenant_pays_area_electric
      t.boolean  :tenant_pays_area_gas
      t.boolean  :tenant_pays_area_oil
      t.boolean  :tenant_pays_area_steam
      t.boolean  :tenant_pays_area_propane
      t.integer  :solar_general_meters_count,              default: 0, null: false
      t.integer  :solar_area_meters_count,                 default: 0, null: false
      t.integer  :apartments_count,                        default: 0, null: false
      t.integer  :areas_count,                             default: 0
      t.string   :other_building_type
      t.string   :object_type,                                         null: false
      t.integer  :n_steam_general_meters,                  default: 0, null: false
      t.integer  :n_steam_area_meters,                     default: 0, null: false
      t.integer  :n_propane_general_meters,                default: 0, null: false
      t.integer  :n_propane_area_meters,                   default: 0, null: false
      t.integer  :n_solar_general_meters,                  default: 0, null: false
      t.integer  :n_solar_area_meters,                     default: 0, null: false
      t.datetime :upload_attempt_on
      t.datetime :successful_upload_on

      t.timestamps
    end
  end
end
