class AuditMeasurePresenter
  attr_reader :audit_measure,
              :audit_measure_value

  delegate :id,
           :name,
           to: :audit_measure

  delegate :notes,
           :value,
           to: :audit_measure_value,
           allow_nil: true

  def initialize(audit_measure, audit_measure_value = nil)
    @audit_measure = audit_measure
    @audit_measure_value = audit_measure_value
  end
end
