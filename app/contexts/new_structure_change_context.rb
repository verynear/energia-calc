class NewStructureChangeContext < BaseContext
  attr_accessor :audit_report,
                :measure_selection,
                :temp_structure,
                :calc_structure,
                :calc_structure_type

  delegate :measure,
           :measure_name,
           to: :measure_selection

  def available_structure_types
    measure.calc_structure_types.select do |calc_structure_type|
      structure_type_definition =
        measure.structure_type_definition_for(calc_structure_type)
      if !structure_type_definition.multiple? &&
          measure_selection.has_structure_change_for(calc_structure_type)
        false
      else
        true
      end
    end
  end

  def grouped_structures_options(calc_structure_type)
    grouped_structures_for_structure_type(calc_structure_type).map do |calc_structure|
      [calc_structure.description_with_quantity, calc_structure.id]
    end +
      [['New structure...', '']]
  end

  private

  def all_structures_for_structure_type(calc_structure_type)
    audit_report.all_structures.select do |calc_structure|
      calc_structure.calc_structure_type.api_name == calc_structure_type.api_name ||
        calc_structure.calc_structure_type.genus_api_name == calc_structure_type.api_name
    end
  end

  def grouped_structures_for_structure_type(calc_structure_type)
    structures = all_structures_for_structure_type(calc_structure_type)
    StructureListGrouper.new(measure_selection, calc_structure_type, structures)
      .grouped_structures
  end
  memoize :grouped_structures_for_structure_type
end
