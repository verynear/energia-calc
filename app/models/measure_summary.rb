class MeasureSummary < Generic::Strict
  attr_accessor :before_usage_values,
                :data,
                :effective_structure_values,
                :measure_selection

  delegate :[], :reduce, :to_h, to: :data

  def initialize(*)
    super
    self.data ||= {}
    self.before_usage_values ||= {}
    self.before_usage_values = IceNine.deep_freeze!(before_usage_values)
    self.effective_structure_values ||= {}
    self.effective_structure_values =
      IceNine.deep_freeze!(effective_structure_values.deep_dup)
    freeze
  end
end
