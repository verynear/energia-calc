class StructureGroupingPresenter
  attr_reader :grouping,
              :structure

  delegate :name,
           to: :grouping

  def initialize(structure, grouping)
    @structure = structure
    @grouping = grouping
  end

  def fields
    grouping.fields.order(:display_order).map do |field|
      StructureFieldPresenter.new(structure, field, field_values[field.id])
    end
  end

  private

  def field_values
    @field_values ||= structure.field_values.map do |field_value|
      [field_value.field_id, field_value]
    end.to_h
  end
end
