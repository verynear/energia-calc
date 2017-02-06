class AuditMeasuresPresenter
  attr_reader :audit

  def initialize(audit)
    @audit = audit
  end

  def measures
    @measures ||= Measure.active.order(:name).map do |measure|
      MeasurePresenter.new(measure, measure_values[measure.id])
    end
  end

  private

  def measure_values
    @measure_values ||= audit.measure_values.map do |measure_value|
      [measure_value.measure_id, measure_value]
    end.to_h
  end
end
