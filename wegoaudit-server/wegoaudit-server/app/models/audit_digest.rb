class AuditDigest

  attr_accessor :audit,
                :audit_report,
			          :field,
			          :measure,
                :measure_value,
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

  def fields_list
    fields_json = Field.uniq(:api_name).order(:id).map do |field|
      options = field.field_enumerations.order(:display_order).pluck(:value)
      { name: field.name,
        value_type: field.value_type,
        api_name: field.api_name,
        options: options
      }
    end

    render json: { fields: fields_json }
  end

  def measures_list
    response = Measure.all.map do |measure|
      { name: measure.name,
        api_name: measure.api_name }
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