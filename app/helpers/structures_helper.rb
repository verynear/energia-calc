module StructuresHelper
  def can_edit?
    !current_audit.is_locked?
  end

  def can_link?(structure)
    return false unless can_edit?

    structure.structure_type.physical_structure_type == 'Building' &&
      !structure.physical_structure&.linked?
  end

  def crumb_links(audit, structure)
    if structure.parent_object == audit
      [[audit.name, audit]]
    else
      crumb_links(audit, structure.parent_object) + [
        [
          structure.name, [audit, structure]
        ]
      ]
    end
  end
end
