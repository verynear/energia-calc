class OriginalStructureFieldValue < ActiveRecord::Base
  belongs_to :audit_report

  delegate :convert_value, to: :field
  delegate :value_type, to: :field
  delegate :name, to: :field, prefix: true

  def field
    Field.by_api_name!(field_api_name)
  end

  def from_audit
    wegoaudit_structure.has_field?(field_api_name)
  end

  def non_wegoaudit_structure
    TempStructure.new(
      id: SecureRandom.uuid,
      temp_audit: temp_audit,
      n_structures: 1,
      name: 'Unnamed',
      field_values: {},
      structure_type: {}
    )
  end

  def original_value
    wegoaudit_structure.field_values
      .fetch(field_api_name, {})['value']
  end

  def value
    convert_value(self[:value])
  end

  def wegoaudit_structure
    audit_report.all_structures.find do |structure|
      structure.id == structure_wegoaudit_id
    end || non_wegoaudit_structure
  end
end
