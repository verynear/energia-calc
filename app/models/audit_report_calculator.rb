class AuditReportCalculator < Generic::Strict
  attr_writer :audit_report

  def audit_report
    FullAuditReport.new(
      audit_report: @audit_report
    )
  end
  memoize :audit_report

  def measure_summaries
    measure_summaries_lookup.values
  end
  memoize :measure_summaries

  def measure_summaries_lookup
    usage_values = audit_report.usage_values.clone
    original_structure_values = audit_report.original_structure_values.clone

    audit_report.measure_selections
      .each_with_object({}) do |measure_selection, hash|
      inputs_hash =
        audit_report.field_values_hash_for_measure_selection(measure_selection)

      calculator = MeasureSelectionCalculator.new(
        measure_selection: measure_selection,
        audit_report_inputs: audit_report.field_values_hash,
        measure_selection_inputs: inputs_hash,
        effective_structure_values: original_structure_values,
        usage_values: usage_values,
        full_audit_report: audit_report
      )

      hash[measure_selection.id] = calculator.measure_summary

      adjust_original_structure_values(calculator, original_structure_values)
      decrement_usage_values(calculator, usage_values)
    end
  end
  memoize :measure_summaries_lookup

  def summary
    summary_hash = build_summary
    summary_hash[:annual_cost_reduction_percentage] =
      get_annual_cost_reduction_percentage(summary_hash)

    [:annual_water_usage_existing,
     :annual_electric_usage_existing,
     :annual_gas_usage_existing,
     :annual_oil_usage_existing].each do |field|
       summary_hash[field] = audit_report.public_send(field)
     end

    summary_hash.each do |key, value|
      summary_hash[key] = :error unless value
    end
  end
  memoize :summary

  def summary_for_measure_selection(measure_selection)
    measure_summaries_lookup.fetch(measure_selection.id) do
      MeasureSummary.new(measure_selection: measure_selection)
    end
  end
  memoize :summary_for_measure_selection

  private

  def adjust_original_structure_values(calculator, original_structure_values)
    original_structure_values.each do |structure_wegoaudit_id, options|
      new_hash = options.each_with_object({}).each do |(key, _value), hash|
        proposed_field_key = "#{key}_proposed".to_sym

        next unless calculator.has_key?(proposed_field_key)

        hash[structure_wegoaudit_id] ||= {}
        hash[structure_wegoaudit_id][key] =
          calculator.value_for(proposed_field_key)
      end

      original_structure_values[structure_wegoaudit_id]
        .merge!(new_hash.fetch(structure_wegoaudit_id, {}))
    end
  end

  def build_summary
    measure_summaries.each_with_object({}) do |measure_summary, hash|
      MeasureSelectionCalculator.calculation_names.each do |name|
        hash[name] ||= nil
        next if hash[name].is_a?(Symbol)

        value = measure_summary[name]
        next unless value

        hash[name] ||= 0
        if value == :infinity
          hash[name] = :infinity
        else
          hash[name] += value
        end
      end
    end
  end

  def decrement_usage_values(calculator, usage_values)
    WegoAudit::BUILDING_USAGE_FIELDS_MAPPING.each do |usage_field, result_field|
      new_value = usage_values[usage_field] -
        (calculator.public_send(result_field) || 0.0)
      usage_values[usage_field] = new_value
    end
  end

  def get_annual_cost_reduction_percentage(summary_hash)
    unless summary_hash[:annual_operating_cost_proposed].is_a?(Numeric)
      return :error
    end

    unless summary_hash[:annual_operating_cost_existing].is_a?(Numeric)
      return :error
    end

    return :infinity if summary_hash[:annual_operating_cost_existing] == 0

    ((summary_hash[:annual_operating_cost_existing] -
     summary_hash[:annual_operating_cost_proposed]) /
    summary_hash[:annual_operating_cost_existing]) * 100
  end
end
