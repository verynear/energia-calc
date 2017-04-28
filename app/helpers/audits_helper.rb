module AuditsHelper
  def link_to_audit(audit)
    link_text = lock_icon(audit)
    link_text << audit.audit_structure.name
    link_to link_text, audit, class: 'row-block-link'
  end

  def lock_icon(audit)
    if audit.is_locked?
      '<i class="icon-locked"></i> '.html_safe
    else
      ''
    end
  end

  def expires_in(audit)
    distance_of_time_in_words_to_now(audit.destroy_on_date)
  end

  def audit_type_options
    audit_types = AuditType.where(active: true)
                           .order(:name)
                           .pluck(:name, :id)
    options_for_select audit_types
  end
end
