class MeasureSelectionCalculator < Generic::Strict
  CALCULATIONS = [
    :annual_energy_usage_existing,
    :annual_energy_savings,
    :annual_water_savings,
    :annual_electric_savings,
    :annual_gas_savings,
    :annual_oil_savings,
    :annual_cost_savings,
    :years_to_payback,
    :cost_of_measure,
    :savings_investment_ratio,
    :utility_rebate,
    :retrofit_lifetime,
    :annual_operating_cost,
    :annual_operating_cost_existing,
    :annual_operating_cost_proposed
  ]

  attr_accessor :audit_report_inputs,
                :effective_structure_values,
                :full_audit_report,
                :measure_selection,
                :measure_selection_inputs,
                :usage_values

  attr_reader :before_usage_values

  delegate :utility_rebate,
           :retrofit_lifetime,
           to: :measure_selection

  def self.calculation_names
    CALCULATIONS
  end

  def initialize(*)
    super
    self.usage_values = @usage_values.clone
    @before_usage_values = @usage_values.clone
    @effective_structure_values = @effective_structure_values.clone
  end

  def annual_cost_savings
    value_for(:annual_cost_savings)
  end

  def annual_electric_savings
    value_for(:annual_electric_savings)
  end

  def annual_energy_savings
    Calculations::AnnualEnergySavings.new(
      calculator: self
    ).call
  end

  def annual_energy_usage_existing
    Calculations::AnnualEnergyUsageExisting.new(
      audit_report: full_audit_report
    ).call
  end

  def annual_gas_savings
    value_for(:annual_gas_savings)
  end

  def annual_maintenance_cost_savings
    value_for(:annual_maintenance_cost_savings)
  end

  def annual_oil_savings
    value_for(:annual_oil_savings)
  end

  def annual_operating_cost
    value_for(:annual_operating_cost)
  end

  def annual_operating_cost_existing
    value_for(:annual_operating_cost_existing)
  end

  def annual_operating_cost_proposed
    value_for(:annual_operating_cost_proposed)
  end

  def annual_water_savings
    value_for(:annual_water_savings)
  end

  def calculations
    determining_structure_change = measure_selection.structure_changes
      .find(&:determining_structure?)

    summation_of_structure_change_values do |structure_change|
      calculations_set = perform_calculations_for(
        structure_change,
        determining_structure_change)
      decrement_usage_values(calculations_set.results)
      calculations_set.results
    end
  end
  memoize :calculations

  def cost_of_measure
    value_for(:cost_of_measure)
  end
  memoize :cost_of_measure

  def degradation_rate
    value_for(:degradation_rate)
  end

  def has_key?(key)
    calculations.has_key?(key.to_sym)
  end

  def measure_summary
    data = CALCULATIONS.each_with_object({}) do |key, hash|
      hash[key] = public_send(key)
    end
    MeasureSummary.new(
      measure_selection: measure_selection,
      before_usage_values: before_usage_values,
      effective_structure_values: effective_structure_values,
      data: data)
  end
  memoize :measure_summary

  def savings_investment_ratio
    Calculations::SavingsInvestmentRatio.new(
      audit_report: full_audit_report,
      calculator: self
    ).call
  end
  memoize :savings_investment_ratio

  def value_for(key)
    calculations[key]
  end
  memoize :value_for

  def years_to_payback
    return :infinity if annual_cost_savings == 0

    value_for(:years_to_payback)
  end
  memoize :years_to_payback

  private

  def average_outdoor_temperature
    options = {
      location:
        audit_report_inputs[:location_for_temperatures],
      warm_weather_shutdown_temperature:
        measure_selection_inputs[:shared][:warm_weather_shutdown_temperature],
      heating_season_end_month:
        audit_report_inputs[:heating_season_end_month],
      heating_season_start_month:
        audit_report_inputs[:heating_season_start_month]
    }
    Calculations::AverageOutdoorTemperature.new(options).call
  end
  memoize :average_outdoor_temperature

  def calculated_inputs
    inputs = {}
    if measure_selection.calc_measure.api_name ==
        'install_temperature_limiting_thermostats'
      inputs[:average_outdoor_temperature] = average_outdoor_temperature
    end
    inputs
  end
  memoize :calculated_inputs

  def decrement_usage_values(results)
    WegoAudit::BUILDING_USAGE_FIELDS_MAPPING.each do |usage_field, result_field|
      value = (results[result_field] || 0)
      usage_values[usage_field] -= value
    end

    %w[annual_gas_savings
       annual_electric_savings
       annual_oil_savings].each do |result_field|
      value = (results[result_field] || 0)

      if result_field == 'annual_electric_savings'
        value = value * 0.034095106405145  # KWH_TO_THERMS_COEFFICIENT
      elsif result_field == 'annual_oil_savings'
        value = value * 0.0000100024  # BTU_TO_THERMS_COEFFICIENT
      end

      if measure_selection.for_building_heating?
        usage_values[:heating_usage_in_therms] -= value
      end

      if measure_selection.for_water_heating?
        usage_values[:heating_fuel_baseload_in_therms] -= value
      end
    end
  end

  def inputs_for(structure_change, type)
    measure_selection_inputs[:structure_changes]
      .fetch(structure_change.id)
      .fetch(type)
  end

  def original_structure_value_inputs(structure_change,
                                      determining_structure_change)
    structure_change_for_effective_structure_values =
      if determining_structure_change
        determining_structure_change
      else
        structure_change
      end

    effective_structure_values.fetch(
      structure_change_for_effective_structure_values.structure_wegoaudit_id,
      {}).symbolize_keys
  end

  def perform_calculations_for(structure_change, determining_structure_change)
    before_inputs = inputs_for(structure_change, :existing)

    before_inputs.merge!(
      original_structure_value_inputs(
        structure_change,
        determining_structure_change
      )
    )
    after_inputs = inputs_for(structure_change, :proposed)

    after_inputs = remap_inputs(after_inputs)
    before_inputs = remap_inputs(before_inputs)

    measure_selection.definition
      .run_retrofit_calculations(
        before_inputs: before_inputs,
        after_inputs: after_inputs,
        shared_inputs: shared_inputs)
  end
  memoize :perform_calculations_for

  def remap_inputs(inputs)
    inputs.each_with_object({}) do |(key, value), hash|
      mapping = measure_selection.definition.fields_mapping.invert[key.to_s]
      if mapping
        hash[mapping.to_sym] = value
      else
        hash[key] = value
      end
    end
  end

  def shared_inputs
    audit_report_inputs
    .merge(usage_values)
    .merge(measure_selection_inputs[:shared])
    .merge(calculated_inputs)
  end
  memoize :shared_inputs

  def summation_of_structure_change_values
    measure_selection.structure_changes
      .each_with_object({}) do |structure_change, summary_hash|
      next if structure_change.determining_structure?

      results_hash = yield structure_change
      return unless results_hash # rubocop:disable Lint/NonLocalExitFromIterator

      results_hash.each do |key, value|
        # next unless value.is_a?(Numeric)

        summary_hash[key] ||= 0
        summary_hash[key] += value
      end
    end
  end
end
