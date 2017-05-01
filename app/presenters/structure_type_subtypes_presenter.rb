class StructureTypeSubtypesPresenter
  attr_reader :audit_strc_type

  def initialize(audit_strc_type, selected = nil)
    @audit_strc_type = audit_strc_type
    @selected_type = AuditStrcType.find(selected) if selected.present?
  end

  def as_json
    {
      types: selectable_types,
      subtypes: selectable_subtypes
    }
  end

  private

  def has_no_subtypes?
    audit_strc_type.primary?
  end

  def ordered_child_structure_types
    @ordered_child_structure_types ||=
      audit_strc_type.child_structure_types.order(:name)
  end

  def selected_type
    @selected_type || ordered_child_structure_types.first
  end

  def selectable_types
    return [[audit_strc_type.name, audit_strc_type.id]] if has_no_subtypes?
    ordered_child_structure_types.pluck(:name, :id)
  end

  def selectable_subtypes
    return [] if has_no_subtypes?
    selected_type.child_structure_types.order(:name).pluck(:name, :id)
  end
end
