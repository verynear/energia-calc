class AuditDigest

  attr_accessor :audit,
                :audit_report,
			          :audit_field,
			          :audit_measure,
                :audit_measure_value,
                :sample_group,
                :structure,
			          :structure_type,
                :user


  def new_audit(audit_id)
    raise ArgumentError unless audit_id.present?

    audit = Audit.find(audit_id)

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

  def audit_measures_list
    response = AuditMeasure.all.map do |audit_measure|
      { name: audit_measure.name,
        api_name: audit_measure.api_name }
    end

    return response
  end

  def structure_types_list
    response = StructureType.uniq(:api_name).order(:id).map do |structure_type|
      next if structure_type.api_name == 'audit'
      Retrocalc::StructureTypeJsonPresenter.new(structure_type).as_json
    end.compact

    return response
  end


end