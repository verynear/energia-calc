class MeasureSummarySerializer < Generic::Strict
  INFINITY_HTMLENTITY = '&#8734;'
  CALCULATION_TITLES = {
    annual_water_savings: 'Annual water savings (gallons)',
    annual_electric_savings: 'Annual electric savings (kwh)',
    annual_gas_savings: 'Annual gas savings (therms)',
    annual_oil_savings: 'Annual oil savings (btu)',
    annual_cost_savings: 'Annual cost savings',
    cost_of_measure: 'Cost of measure',
    years_to_payback: 'Years to payback',
    savings_investment_ratio: 'SIR'
  }

  USAGE_VALUE_TITLES = {
    heating_fuel_baseload_in_therms: 'Heating fuel baseload (therms)',
    heating_usage_in_therms: 'Building Heating (therms)',
    water_usage_in_gallons: 'Water (gallons)',
    electric_usage_in_kwh: 'Electric (kwh)',
    gas_usage_in_therms: 'Gas (therms)',
    oil_usage_in_btu: 'Oil (btu)'
  }

  include ActionView::Helpers::NumberHelper

  attr_accessor :measure_selection,
                :measure_summary

  delegate :measure_selection, to: :measure_summary

  def initialize(*)
    super
    raise ArgumentError, :measure_summary unless measure_summary
  end

  def as_json
    {
      id: measure_selection.id,
      report_id: measure_selection.audit_report.id,
      description: measure_selection.description,
      recommendation: measure_selection.recommendation,
      calc_field_values: field_values_as_json,
      results: summary_for_json,
      before_usage_values: usage_values_as_json
    }
  end

  def summary
    data = measure_summary.reduce({}) do |hash, (key, value)|
      if value == :infinity
        hash[key] = INFINITY_HTMLENTITY
      elsif value
        if [:annual_cost_savings, :cost_of_measure].include?(key)
          hash[key] = value
        else
          hash[key] = value.round(precision_for(value))
        end
      else
        hash[key] = 'Missing fields'
      end
      hash
    end
    cast_fields_to_currency(
      data,
      :annual_cost_savings,
      :cost_of_measure)
    cast_fields_to_delimited(
      data,
      :annual_water_savings,
      :annual_electric_savings,
      :annual_gas_savings,
      :annual_oil_savings,
      :years_to_payback,
      :retrofit_lifetime)
    data
  end

  def summary_for_json
    summary.slice(*measure_selection.relevant_calculations).map do |key, value|
      { name: key, value: value, title: CALCULATION_TITLES[key] }
    end
  end

  private

  def cast_fields_to_currency(hash, *fields)
    fields.each do |field|
      next if hash[field].is_a?(String)
      hash[field] = number_to_currency(hash[field])
    end
  end

  def cast_fields_to_delimited(hash, *fields)
    fields.each do |field|
      next if hash[field].is_a?(String)
      hash[field] = number_with_delimiter(hash[field])
    end
  end

  def field_values_as_json
    measure_selection.calc_field_values.map do |field_value|
      {
        id: field_value.id,
        name: field_value.calc_field_name,
        value: field_value.value,
        value_type: field_value.value_type,
        original_value: field_value.original_value,
        from_audit: field_value.from_audit,
        api_name: field_value.field_api_name,
        options: field_value.calc_field_options,
        default: measure_selection.defaults[field_value.field_api_name.to_sym]
      }
    end
  end

  def precision_for(value)
    [0, 2 - Math.log10([value, 0.01].max).floor].max
  end

  def usage_values_as_json
    measure_summary.before_usage_values.symbolize_keys
      .slice(*measure_selection.relevant_usage_fields)
      .each_with_object({}) do |(key, value), hash|
        hash[key] = {
          value: value,
          title: USAGE_VALUE_TITLES[key]
        }
      end
  end
end
