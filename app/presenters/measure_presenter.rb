class MeasurePresenter
  attr_reader :measure,
              :measure_value

  delegate :id,
           :name,
           to: :measure

  delegate :notes,
           :value,
           to: :measure_value,
           allow_nil: true

  def initialize(measure, measure_value = nil)
    @measure = measure
    @measure_value = measure_value
  end
end
