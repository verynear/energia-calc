class MeasureSelection < ActiveRecord::Base
  include RankedModel
  ranks :calculate_order, with_same: :audit_report_id

  validates :calc_measure_id, presence: true
  validates :audit_report_id, presence: true

  belongs_to :calc_measure
  belongs_to :audit_report
  has_many :calc_field_values, as: :parent

  has_many :structure_changes
  has_many :calc_structures, through: :structure_changes

  delegate :temp_audit, to: :audit_report
  delegate :structure_types, to: :calc_measure
  delegate :fields_for_structure_type, to: :calc_measure
  delegate :grouping_field_api_name, to: :calc_measure
  delegate :name, to: :calc_measure, prefix: true
  delegate :definition, to: :calc_measure, prefix: true
  delegate :data_types,
           :defaults,
           :interaction_fields,
           :interaction_fields_for,
           :structure_type_definition_for,
           :for_water_heating?,
           :for_building_heating?,
           :for_water?,
           :for_electric?,
           :for_gas?,
           :for_oil?,
           to: :calc_measure_definition

  def belongs_to_user?(user)
    audit_report.user == user
  end

  def degradation_rate
    calc_field_value('degradation_rate')
  end

  def has_structure_change_for(calc_structure_type)
    structure_changes.where(calc_structure_type_id: calc_structure_type.id).exists?
  end

  def relevant_calculations
    [
      :cost_of_measure,
      :annual_cost_savings,
      :years_to_payback,
      :savings_investment_ratio
    ] + relevant_energy_calculations
  end

  def relevant_energy_calculations
    fields = []
    fields << :annual_electric_savings if for_electric?
    fields << :annual_gas_savings if for_gas?
    fields << :annual_oil_savings if for_oil?
    fields << :annual_water_savings if for_water?
    fields
  end

  def relevant_usage_fields
    fields = []
    fields << :heating_fuel_baseload_in_therms if for_water_heating?
    fields << :heating_usage_in_therms if for_building_heating?
    fields << :electric_usage_in_kwh if for_electric?
    fields << :electric_usage_in_kwh if for_electric?
    fields << :gas_usage_in_therms if for_gas?
    fields << :oil_usage_in_btu if for_oil?
    fields << :water_usage_in_gallons if for_water?
    fields
  end

  def retrofit_lifetime
    value = calc_field_value('retrofit_lifetime')
    return value if value.present?

    defaults[:retrofit_lifetime]
  end

  def utility_rebate
    calc_field_value('utility_rebate')
  end

  def warm_weather_shutdown_temperature
    calc_field_value('warm_weather_shutdown_temperature')
  end

  private

  def calc_field_value(api_name)
    calc_field_values.find_by(field_api_name: api_name).value
  end
end