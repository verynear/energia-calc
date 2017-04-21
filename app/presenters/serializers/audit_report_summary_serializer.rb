class AuditReportSummarySerializer < Generic::Strict
  INFINITY_HTMLENTITY = '&#8734;'

  include ActionView::Helpers::NumberHelper

  attr_accessor :audit_report,
                :audit_report_calculator

  def initialize(*)
    super
    self.audit_report_calculator ||= AuditReportCalculator.new(
      audit_report: audit_report)
    @audit_report = audit_report_calculator.audit_report
  end

  def as_json
    {
      id: audit_report.id,
      effective_structure_values_lookup: effective_structure_values_lookup,
      measure_summaries: measure_summaries_json
    }.merge(audit_totals_json)
  end

  private

  def audit_totals_json
    json = audit_report_calculator.summary.reduce({}) do |hash, (key, value)|
      if value == :error
        hash[key] = '?'
      elsif value == :infinity
        hash[key] = INFINITY_HTMLENTITY
      else
        if [:annual_cost_savings, :cost_of_measure].include?(key)
          hash[key] = value
        else
          hash[key] = value.round(precision_for(value))
        end
      end
      hash
    end
    cast_fields_to_currency(
      json,
      :annual_cost_savings,
      :cost_of_measure,
      :utility_rebate)
    cast_fields_to_delimited(
      json,
      :annual_energy_savings,
      :annual_water_savings,
      :years_to_payback)
    json
  end

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

  def effective_structure_values_lookup
    audit_report_calculator.measure_summaries_lookup
      .each_with_object({}) do |(id, summary), hash|
        hash[id] = summary.effective_structure_values
      end
  end

  def measure_summaries_json
    audit_report.measure_selections.map do |measure_selection|
      measure_summary =
        audit_report_calculator.summary_for_measure_selection(measure_selection)
      MeasureSummarySerializer.new(measure_summary: measure_summary).as_json
    end
  end

  def precision_for(value)
    [0, 2 - Math.log10([value, 0.01].max).floor].max
  end
end
