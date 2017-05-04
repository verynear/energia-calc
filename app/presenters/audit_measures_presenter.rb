class AuditMeasuresPresenter
  attr_reader :audit

  def initialize(audit)
    @audit = audit
  end

  def audit_measures
    @audit_measures ||= AuditMeasure.active.order(:name).map do |audit_measure|
      AuditMeasurePresenter.new(audit_measure, audit_measure_values[audit_measure.id])
    end
  end

  private

  def audit_measure_values
    @audit_measure_values ||= audit.audit_measure_values.map do |audit_measure_value|
      [audit_measure_value.audit_measure_id, audit_measure_value]
    end.to_h
  end
end
