class StructureGroupingPresenter
  attr_reader :grouping,
              :structure,
              :field,
              :field_value

  delegate :name,
           to: :grouping

  def initialize(structure, grouping)
    @structure = structure
    @grouping = grouping
  end

  def fields
      grouping.fields.order(:display_order).map do |field|
        if field.value_type != 'picker'
           StructureFieldPresenter.new(structure, field, field_values[field.id])
        else
          if field_values.empty?
            StructureFieldPresenter.new(structure, field, collection)
          else
            StructureFieldPresenter.new(structure, field, collection, field_values[field.id]['string_value'])
          end
        end
      end
  end  

  private

    
    def field_values
      @field_values ||= structure.field_values.map do |field_value|
        [field_value.field_id, field_value]
      end.to_h
    end

    def collection
      collection = []
      grouping.field_enumerations.map do |field_enumeration|
        collection << [field_enumeration.value]
      end
      collection
    end

end
