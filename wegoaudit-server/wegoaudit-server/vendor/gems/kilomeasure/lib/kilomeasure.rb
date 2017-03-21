require 'kilomeasure/support'
require 'kilomeasure/formula'
require 'kilomeasure/formulas_collection'
require 'kilomeasure/measure'
require 'kilomeasure/input'
require 'kilomeasure/calculation'
require 'kilomeasure/calculations_set'
require 'kilomeasure/measure_loader'
require 'kilomeasure/measures_registry'
require 'kilomeasure/inputs_formatter'
require 'kilomeasure/inputs_validator'
require 'kilomeasure/bulk_calculations_runner'
require 'kilomeasure/retrofit_calculations_runner'
require 'kilomeasure/retrofit_results'

module Kilomeasure
  DATA_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', 'data'))

  CALCULATION_CONSTANTS = {
    pi: Math::PI,
    E: Math::E,
    # physical constants
    ideal_gas_constant: 8.3145, # Joule / (deg K * mol)
    specific_heat_of_water: 8.2, # Btu / (gal * deg F)
    water_heat_of_vaporization: 940, # Btu / lb
    # program constants
    boiler_fires_per_day: 5,
    # time conversions
    days_per_year: 365,
    hours_per_day: 24,
    minutes_per_hour: 60,
    weeks_per_year: 52,
    btu_therms_conversion: 0.00001,
    kbtu_therms_conversion: 100,
    therms_btu_conversion: 99_976.1,
    therms_kwh_conversion: 29.3,
    wh_kwh_conversion: 0.001,
    # length, area, volume conversions
    ft2_in2_conversion: 144,
    ft3_gal_conversion: 7.48052,
    ft_in_conversion: 12,
    gal_liter_conversion: 3.78541,
    in2_ft2_conversion: 0.00694,
    in_ft_conversion: 0.08333,
    # other conversions
    mol_lb_conversion_for_water: 0.039717,
    psi_kpa_conversion: 6.89476,
  }

  DEFAULT_FORMULAS = {
    annual_electric_cost:
      'annual_electric_usage * electric_cost_per_kwh',
    annual_gas_cost:
      'annual_gas_usage * gas_cost_per_therm',
    annual_oil_cost:
      'annual_oil_usage * oil_cost_per_btu',
    annual_water_cost:
      'annual_water_usage * water_cost_per_gallon'
  }

  DEFAULT_OUTPUT_FORMULAS = {
    cost_of_measure:
      'retrofit_cost_proposed',
    annual_water_savings:
      'annual_water_usage_existing - annual_water_usage_proposed',
    annual_electric_savings:
      'annual_electric_usage_existing - annual_electric_usage_proposed',
    annual_gas_savings:
      'annual_gas_usage_existing - annual_gas_usage_proposed',
    annual_oil_savings:
      'annual_oil_usage_existing - annual_oil_usage_proposed',
    annual_cost_savings:
      'annual_operating_cost_existing - annual_operating_cost_proposed',
    years_to_payback:
      'cost_of_measure / annual_cost_savings'
  }

  DATA_TYPES_REGEXP = /(water|electric|gas|oil|heating|water_heating)/

  def self.measures
    MeasuresRegistry.instance.all
  end

  def self.add_measure(name, data)
    MeasuresRegistry.set(name, data)
  end

  def self.get_measure(name)
    MeasuresRegistry.get(name)
  end

  def self.load(data_path: DATA_PATH)
    MeasuresRegistry.load(data_path: data_path)
  end

  def self.registry
    MeasuresRegistry.instance
  end

  def self.reset
    MeasuresRegistry.reset
  end
end
