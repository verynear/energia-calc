class StructureChangeSerializer < Generic::Strict
  attr_accessor :measure_selection,
                :measure_summary,
                :structure_change

  def as_json
    {
      id: structure_change.id,
      structure_type_name: structure_type_name,
      original_structure: structure_as_json(structure_change.original_structure),
      proposed_structure: structure_as_json(structure_change.proposed_structure)
    }
  end

  private

  def structure_as_json(calc_structure)
    effective_structure_values = measure_summary
      .effective_structure_values.fetch(
        structure_change.structure_wegoaudit_id,
        {})

    StructureSerializer.new(
      calc_structure: calc_structure,
      structure_change: structure_change,
      effective_structure_values: effective_structure_values,
      measure_selection: measure_selection).as_json
  end

  def structure_type_name
    structure_change.calc_structure_type.name
  end
  memoize :structure_type_name
end
