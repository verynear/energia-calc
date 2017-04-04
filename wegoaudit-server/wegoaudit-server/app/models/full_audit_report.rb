class FullAuditReport < Generic::Strict
  attr_accessor :audit_report

  delegate :id, to: :audit_report

  def initialize(*)
    super
  end

  def annual_electric_usage_existing
    usage_values[:electric_usage_in_kwh]
  end

  def annual_gas_usage_existing
    usage_values[:gas_usage_in_therms]
  end

  def annual_oil_usage_existing
    usage_values[:oil_usage_in_btu]
  end

  def annual_water_usage_existing
    usage_values[:water_usage_in_gallons]
  end

  def escalation_rate
    field_values_hash[:escalation_rate]
  end

  def field_values_hash
    field_values_for_object(audit_report)
  end
  memoize :field_values_hash

  def field_values_hash_for_measure_selection(measure_selection)
    measure_selection_field_values_lookup.fetch(measure_selection.id)
  end

  def inflation_rate
    field_values_hash[:inflation_rate]
  end

  def interest_rate
    field_values_hash[:interest_rate]
  end

  def measure_selections
    audit_report.measure_selections
      .where(enabled: true)
      .includes(:structure_changes, :calc_structures, :calc_field_values)
      .joins(:structure_changes, :calc_structures, :calc_field_values)
      .rank(:calculate_order)
      .select('structure_changes.*', 'calc_structures.*', 'calc_field_values.*')
  end
  memoize :measure_selections

  def original_structure_values
    audit_report.original_structure_field_values
      .pluck_to_hash(:value, :field_api_name, :structure_wegoaudit_id)
      .each_with_object({}) do |row, hash|
        structure_wegoaudit_id = row[:structure_wegoaudit_id]
        field_api_name = row[:field_api_name]
        value = row[:value]
        hash[structure_wegoaudit_id] ||= {}
        value = CalcField.by_api_name!(field_api_name).calc_convert_value(value)
        hash[structure_wegoaudit_id][field_api_name] = value
      end
  end
  memoize :original_structure_values

  def usage_values
    field_values_hash.slice(*WegoAudit::BUILDING_USAGE_FIELDS)
      .each_with_object({}) do |(key, value), hash|
      hash[key] ||= value
      hash[key] ||= 0
    end
  end
  memoize :usage_values

  private

  def determining_structure_change_hash_for(measure_selection)
    structure_change =
      measure_selection.structure_changes.find(&:determining_structure?)
    return {} unless structure_change

    {
      existing: field_values_for_object(structure_change.original_structure),
      proposed: field_values_for_object(structure_change.proposed_structure)
    }
  end

  def field_values_for_measure_selection(measure_selection)
    field_values_for_object(measure_selection)
  end

  def field_values_for_object(object)
    object.calc_field_values.pluck(:field_api_name, :value)
      .each_with_object({}) do |(field_api_name, value), hash|
      value = CalcField.by_api_name!(field_api_name).calc_convert_value(value)
      hash[field_api_name] = value
    end.symbolize_keys
  end

  def field_values_for_structure_change(structure_change,
                                        determining_structure_change_hash = {})
    hash = {
      existing: field_values_for_object(structure_change.original_structure),
      proposed: field_values_for_object(structure_change.proposed_structure)
    }

    hash[:existing]
      .merge!(determining_structure_change_hash.fetch(:existing, {}))
    hash[:proposed]
      .merge!(determining_structure_change_hash.fetch(:proposed, {}))

    hash[:existing][:quantity] = structure_change.original_structure.quantity
    hash[:proposed][:quantity] = structure_change.proposed_structure.quantity
    hash
  end

  def measure_selection_field_values_lookup
    measure_selections.each_with_object({}) do |measure_selection, hash|
      hash[measure_selection.id] = {}
      hash[measure_selection.id][:shared] =
        field_values_for_measure_selection(measure_selection)

      hash[measure_selection.id][:structure_changes] = {}

      measure_selection.structure_changes.each do |structure_change|
        next if structure_change.determining_structure?

        hash[measure_selection.id][:structure_changes][structure_change.id] =
          field_values_for_structure_change(
            structure_change,
            determining_structure_change_hash_for(measure_selection))
      end
    end
  end
  memoize :measure_selection_field_values_lookup
end
