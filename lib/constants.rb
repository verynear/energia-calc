module Retrocalc
  BASE_URL =
    case Rails.env
    when 'production' then 'https://retrocalc.herokuapp.com/'
    when 'staging' then 'https://retrocalc.herokuapp.com/'
    when 'development' then "http://#{ENV['WEGOAUDIT_LOCAL_IP']}:9292"
    when 'test' then "http://#{ENV['WEGOAUDIT_LOCAL_IP']}:9292"
    end

  BUILDING_USAGE_FIELDS_MAPPING = {
    heating_fuel_baseload_in_therms: :annual_gas_savings,
    heating_usage_in_therms: :annual_gas_savings,
    water_usage_in_gallons: :annual_water_savings,
    electric_usage_in_kwh: :annual_electric_savings,
    gas_usage_in_therms: :annual_gas_savings,
    oil_usage_in_btu: :annual_oil_savings
  }

  BUILDING_USAGE_FIELDS = BUILDING_USAGE_FIELDS_MAPPING.keys

  USAGE_TYPES = [
    :water,
    :electric,
    :gas,
    :oil,
    :water_heating,
    :building_heating]

  DOORSTOP_SHARED_SECRET = 's3kr3t'

  KWH_TO_BTU_COEFFICIENT = 3_412.14163312794
  KWH_TO_THERMS_COEFFICIENT = 0.034095106405145
  THERMS_TO_BTU_COEFFICIENT = 100_000
  BTU_TO_THERMS_COEFFICIENT = 1.0 / 100_000
end
