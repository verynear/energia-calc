class WegoauditClient

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :wegowise_id,
                :organization_id
                :audit

  def initialize(organization_id: nil)
    self.organization_id = organization_id
  end

  def persisted?
    false
  end

  def audit(audit_id)
    raise ArgumentError unless audit_id.present?

    audit = Audit.where(organization_id: organization_id).find(id: audit_id)

    response = Retrocalc::AuditJsonPresenter.new(audit)

    return response
  end

  def audits_list
    response = Audit.where(organization_id: organization_id) do |audit|
      Retrocalc::AuditJsonPresenter.new(audit, top_level_only: true)
    end

    return response
  end

  def fields_list
    response = Field.uniq(:api_name).order(:id).map do |field|
      options = field.field_enumerations.order(:display_order).pluck(:value)
      { name: field.name,
        value_type: field.value_type,
        api_name: field.api_name,
        options: options
      }
    end

    return response
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