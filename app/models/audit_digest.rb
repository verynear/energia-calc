class AuditDigest

  attr_accessor :audit,
                :audit_report,
			          :audit_field,
                :sample_group,
                :audit_structure,
			          :audit_strc_type,
                :user


  def new_audit(audit_id)
    raise ArgumentError unless audit_id.present?

    audit = Audit.includes(audit_structure: [:sample_groups, :physical_structure]).find(audit_id)

    Retrocalc::AuditJsonPresenter.new(audit).as_json
  end

  def audits_list
    Audit.all.map do |audit|
      Retrocalc::AuditJsonPresenter.new(audit, top_level_only: true)
    end.as_json
  end

  def audit_fields_list
    audit_fields_json = AuditField.uniq(:api_name).order(:id).map do |audit_field|
      options = audit_field.field_enumerations.order(:display_order).pluck(:value)
      { name: audit_field.name,
        value_type: audit_field.value_type,
        api_name: audit_field.api_name,
        options: options
      }
    end

    render json: { audit_fields: audit_fields_json }
  end


  def structure_types_list
    response = AuditStrcType.uniq(:api_name).order(:id).map do |audit_strc_type|
      next if audit_strc_type.api_name == 'audit'
      Retrocalc::StructureTypeJsonPresenter.new(audit_strc_type).as_json
    end.compact

    return response
  end


end