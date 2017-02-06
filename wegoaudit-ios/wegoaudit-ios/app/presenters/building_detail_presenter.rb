class BuildingDetailPresenter < StructureDetailPresenter
  def base_form
    { sections: building_sections }
  end

  def building_sections
    [
      { title: 'Address',
        rows: [
          { title: 'Name', type: 'string', key: 'name', value: physical_structure.name },
          { title: 'Draft', type: 'switch', key: 'draft', value: physical_structure.draft },
          { title: 'Street Address', key: 'street_address', type: 'string', value: physical_structure.street_address },
          { title: 'City', key: 'city', type: 'string', value: physical_structure.city },
          { title: 'Climate zone', key: 'climate_zone', type: 'string', value: physical_structure.climate_zone },
          { title: 'State', key: 'state_code', type: 'picker', value: physical_structure.state_code, items: Field::STATE_CODES  },
          { title: 'Country', key: 'country', type: 'string', value: physical_structure.country || 'United States' },
          { title: 'County', key: 'county', type: 'string', value: physical_structure.county },
          { title: 'Zip code', key: 'zip_code', type: 'string', value: physical_structure.zip_code },
          { title: 'Latitude', key: 'lat', type: 'string', value: physical_structure.lat },
          { title: 'Longitude', key: 'lng', type: 'string', value: physical_structure.lng },
          { title: 'Low Income', key: 'low_income', type: 'switch', value: physical_structure.low_income }
        ]
      },
      {
        title: 'Building Characteristics',
        rows: [
          { title: 'Building Type', key: 'building_type', type: 'picker', value: physical_structure.building_type, items: BUILDING_TYPES },
          { title: 'Total square footage', key: 'sqft', type: 'number', value: physical_structure.sqft },
          { title: 'Conditioned square footage', key: 'conditioned_sqft', type: 'number', value: physical_structure.conditioned_sqft },
          { title: 'Year Built', key: 'year_built', type: 'number', value: physical_structure.year_built },
          { title: 'Construction', key: 'construction', type: 'picker', value: physical_structure.construction, items: CONSTRUCTIONS },
          { title: 'Number of bedrooms', key: 'n_bedrooms', type: 'number', value: physical_structure.n_bedrooms },
          { title: 'Number of apartments', key: 'n_apartments', type: 'number', value: physical_structure.n_apartments },
          { title: 'Apartment square footage', key: 'apartment_sqft', type: 'number', value: physical_structure.apartment_sqft },
          { title: 'Number of stories', key: 'n_stories', type: 'number', value: physical_structure.n_stories },
          { title: 'Number of Elevators', key: 'n_elevators', type: 'number', value: physical_structure.n_elevators },
          { title: 'Has basement?', key: 'has_basement', type: 'picker', value: physical_structure.has_basement },
          { title: 'Basement is conditioned?', key: 'basement_conditioned', type: 'switch', value: physical_structure.basement_conditioned },
          { title: 'Basement square footage', key: 'basement_sqft', type: 'number', value: physical_structure.basement_sqft },
        ]
      },
      {
        title: 'Resident Characteristics',
        rows: [
          { title: 'Public Housing?', key: 'public_housing', type: 'switch', value: physical_structure.public_housing },
          { title: 'Resident Type', key: 'resident_type', type: 'picker', value: physical_structure.resident_type, items: RESIDENT_TYPES }
        ]
      },
      {
        title: 'Certifications',
        rows: [
          { title: 'EPA certified?', key: 'epa_certified', type: 'switch', value: physical_structure.epa_certified },
          { title: 'Green certified?', key: 'green_certified', type: 'switch', value: physical_structure.green_certified },
          { title: 'NAHB Certified?', key: 'nahb_certified', type: 'switch', value: physical_structure.nahb_certified },
          { title: 'Leed certified?', key: 'leed_certified', type: 'switch', value: physical_structure.leed_certified },
          { title: 'Leed level', key: 'leed_level', type: 'picker', value: physical_structure.leed_level, items: LEED_LEVELS },
          { title: 'Other certified?', key: 'other_certified', type: 'switch', value: physical_structure.other_certified },
        ]
      },
      {
        title: 'Heating, Cooling, and Meters',
        rows: [
          { title: 'Heating system', key: 'heating_system', type: 'picker', value: physical_structure.heating_system, items: HEATING_SYSTEMS },
          { title: 'Heating fuel', key: 'heating_fuel', type: 'picker', value: physical_structure.heating_fuel, items: HEATING_FUELS },
          { title: 'Hot water system', key: 'hot_water_system', type: 'picker', value: physical_structure.hot_water_system, items: HOT_WATER_SYSTEMS },
          { title: 'Hot water fuel', key: 'hot_water_fuel', type: 'picker', value: physical_structure.hot_water_fuel, items: HOT_WATER_FUELS },
          { title: 'Cooling system', key: 'cooling_system', type: 'picker', value: physical_structure.cooling_system, items: COOLING_SYSTEMS },
          { title: 'Number of electric area meters', key: 'n_electric_area_meters', type: 'number', value: physical_structure.n_electric_area_meters },
          { title: 'Number of electric general meters', key: 'n_electric_general_meters', type: 'number', value: physical_structure.n_electric_general_meters },
          { title: 'Tenant pays area electric?', key: 'tenant_pays_area_electric', type: 'switch', value: physical_structure.tenant_pays_area_electric },
          { title: 'Number of gas area meters', key: 'n_gas_area_meters', type: 'number', value: physical_structure.n_gas_area_meters },
          { title: 'Number of gas general meters', key: 'n_gas_general_meters', type: 'number', value: physical_structure.n_gas_general_meters },
          { title: 'Tenant pays area gas?', key: 'tenant_pays_area_gas', type: 'switch', value: physical_structure.tenant_pays_area_gas },
          { title: 'Number of water area meters', key: 'n_water_area_meters', type: 'number', value: physical_structure.n_water_area_meters },
          { title: 'Number of water general meters', key: 'n_water_general_meters', type: 'number', value: physical_structure.n_water_general_meters },
          { title: 'Tenant pays area water?', key: 'tenant_pays_area_water', type: 'switch', value: physical_structure.tenant_pays_area_water },
          { title: 'Number of oil area meters', key: 'n_oil_area_meters', type: 'number', value: physical_structure.n_oil_area_meters },
          { title: 'Number of oil general meters', key: 'n_oil_general_meters', type: 'number', value: physical_structure.n_oil_general_meters },
          { title: 'Tenant pays area oil?', key: 'tenant_pays_area_oil', type: 'switch', value: physical_structure.tenant_pays_area_oil },
          { title: 'Number of propane area meters', key: 'n_propane_area_meters', type: 'number', value: physical_structure.n_propane_area_meters },
          { title: 'Number of propane general meters', key: 'n_propane_general_meters', type: 'number', value: physical_structure.n_propane_general_meters },
          { title: 'Tenant pays area propane?', key: 'tenant_pays_area_propane', type: 'switch', value: physical_structure.tenant_pays_area_propane },
          { title: 'Number of steam area meters', key: 'n_steam_area_meters', type: 'number', value: physical_structure.n_steam_area_meters },
          { title: 'Number of steam general meters', key: 'n_steam_general_meters', type: 'number', value: physical_structure.n_steam_general_meters },
          { title: 'Tenant pays area steam?', key: 'tenant_pays_area_steam', type: 'switch', value: physical_structure.tenant_pays_area_steam },
          { title: 'Number of solar area meters', key: 'n_solar_area_meters', type: 'number', value: physical_structure.n_solar_area_meters },
          { title: 'Number of solar general meters', key: 'n_solar_general_meters', type: 'number', value: physical_structure.n_solar_general_meters }
        ]
      }
    ]
  end

  SINGLE_FAMILY_TYPES = %w[sf_detached sf_attached apt_condo mobile_home]
  MULTI_FAMILY_TYPES = %w[multifamily lowrise midrise highrise]
  BUILDING_TYPES = SINGLE_FAMILY_TYPES + MULTI_FAMILY_TYPES

  RESIDENT_TYPES = %w[elderly student family other]

  CONSTRUCTIONS = %w[wood_steel concrete masonry modular sips other]

  HEATING_FUELS = %w[Electric Gas Oil Steam Propane]
  # Note: solar here has nothing to do with the data type
  HOT_WATER_FUELS = %w[Electric Oil Gas Steam Propane Solar]

  COOLING_SYSTEMS = %w[window_ac
                       sleeve
                       mini_split
                       ptac
                       central
                       rooftop
                       ground_heat_pump
                       tower_heat_pump
                       air_chiller
                       water_chiller
                       none
                       other]

  HEATING_SYSTEMS = %w[furnace
                       h_e_furnace
                       steam_boiler
                       hot_water_boiler
                       h_e_boiler
                       apt_heat_pumps
                       ground_heat_pump
                       air_heat_pump
                       hot_water
                       h_e_hot_water
                       baseboard
                       ptac
                       other]

  HOT_WATER_SYSTEMS  = %w[indirect_with_heat
                          indirect_boiler
                          tankless_coil
                          stand_alone
                          on_demand
                          cogen
                          other]

  LEED_LEVELS = %w[Platinum Gold Silver Certified]

  DRYER_FUELS = %w[Electric Gas]

  # Note: solar here has nothing to do with the data type
  POOL_FUELS = %w[none electric gas solar]
end
