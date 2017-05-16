class NewStructureChangeContext < BaseContext
  attr_accessor :audit_report,
                :measure_selection

  delegate :measure,
           :measure_name,
           to: :measure_selection

  def available_structure_types
    measure.structure_types.select do |structure_type|
      structure_type_definition =
        measure.structure_type_definition_for(structure_type)
      if !structure_type_definition.multiple? &&
          measure_selection.has_structure_change_for(structure_type)
        false
      else
        true
      end
    end
  end

  def grouped_structures_options(structure_type)
    grouped_structures_for_structure_type(structure_type).map do |temp_structure|
      [temp_structure.description_with_quantity, temp_structure.id]
    end +
      [['New structure...', '']]
  end

  private

  def all_structures_for_structure_type(structure_type)
    audit_report.all_structures.select do |temp_structure|
      temp_structure.structure_type.api_name == structure_type.api_name ||
        temp_structure.structure_type.genus_api_name == structure_type.api_name
    end
  end

  def grouped_structures_for_structure_type(structure_type)
    temp_structures = all_structures_for_structure_type(structure_type)
    StructureListGrouper.new(measure_selection, structure_type, temp_structures)
      .grouped_structures
  end
  memoize :grouped_structures_for_structure_type
end
