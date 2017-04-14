class OriginalStructureFieldValue < ActiveRecord::Base
  belongs_to :audit_report

  delegate :calc_convert_value, to: :calc_field
  delegate :value_type, to: :calc_field
  delegate :name, to: :calc_field, prefix: true

  def calc_field
    CalcField.by_api_name!(field_api_name)
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
      calc_field_values: {},
      calc_structure_type: {}
    )
  end

  def original_value
    wegoaudit_structure.calc_field_values
      .fetch(field_api_name, value)
  end

  def value
    calc_convert_value(self[:value])
  end

  def wegoaudit_structure
    audit_report.all_structures.find do |calc_structure|
      calc_structure.id == structure_wegoaudit_id
    end || non_wegoaudit_structure
  end
end
