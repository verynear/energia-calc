class FieldValue < ActiveRecord::Base
  belongs_to :parent, polymorphic: true


  delegate :convert_value, to: :field
  delegate :value_type, to: :field
  delegate :name, to: :field, prefix: true
  delegate :options, to: :field, prefix: true

  def field
    Field.by_api_name!(field_api_name)
  end

  def from_audit
    return false unless parent.is_a?(Structure) || parent.is_a?(AuditStructure)

    parent.wegoaudit_structure.has_field?(field_api_name)
  end

  def original_value
    return nil unless parent.is_a?(Structure) || parent.is_a?(AuditStructure)

    parent.wegoaudit_structure.field_values
      .fetch(field_api_name, {})['value']
  end

  def value
    convert_value(self[:value])
  end
end
