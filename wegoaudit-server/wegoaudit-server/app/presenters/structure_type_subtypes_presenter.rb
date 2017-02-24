class StructureTypeSubtypesPresenter
  attr_reader :structure_type

  def initialize(structure_type, selected = nil)
    @structure_type = structure_type
    @selected_type = StructureType.find(selected) if selected.present?
  end

  def as_json
    {
      types: selectable_types,
      subtypes: selectable_subtypes
    }
  end

  private

  def has_no_subtypes?
    structure_type.primary?
  end

  def ordered_child_structure_types
    @ordered_child_structure_types ||=
      structure_type.child_structure_types.order(:name)
  end

  def selected_type
    @selected_type || ordered_child_structure_types.first
  end

  def selectable_types
    return [[structure_type.name, structure_type.id]] if has_no_subtypes?
    ordered_child_structure_types.pluck(:name, :id)
  end

  def selectable_subtypes
    return [] if has_no_subtypes?
    selected_type.child_structure_types.pluck(:name, :id)
  end
end
