module AuditStructuresHelper
  def can_edit?
    !current_audit.is_locked?
  end

  def can_link?(audit_structure)
    return false unless can_edit?

    audit_structure.audit_strc_type.physical_structure_type == 'Building' &&
      !audit_structure.physical_structure.linked?
  end

  def crumb_links(audit, audit_structure)
    if audit_structure.parent_object == audit
      [[audit.name, audit]]
    else
      crumb_links(audit, audit_structure.parent_object) + [
        [
          audit_structure.name, [audit, audit_structure]
        ]
      ]
    end
  end

  def audit_strc_type_options
    audit_strc_types = AuditStrcType.where(id: audit_strc_type_id)
                           .order(:name)
                           .pluck(:name, :id)
    options_for_select audit_strc_types
  end
end
