class MeasureSelectionCreator < Generic::Strict
  attr_accessor :audit_report,
                :calc_measure,
                :notes

  attr_reader :measure_selection

  def create
    execute
    measure_selection
  end

  def execute
    ActiveRecord::Base.transaction do
      create_measure_selection

      create_field_values
    end
  end

  private

  def create_field_values
    measure_selection.measure_definition.measure_fields.each do |calc_field|
      measure_selection.calc_field_values.create!(field_api_name: calc_field.api_name)
    end
  end

  def create_measure_selection
    @measure_selection = MeasureSelection.create!(
      audit_report: audit_report,
      measure: measure,
      notes: notes
    )
  end
end
