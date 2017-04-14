class CalcFieldValue < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :calc_field

  delegate :calc_convert_value, to: :calc_field
  delegate :value_type, to: :calc_field
  delegate :name, to: :calc_field, prefix: true
  delegate :options, to: :calc_field, prefix: true

  def calc_field
    CalcField.by_api_name!(field_api_name)
  end

  def from_audit
    return false unless parent.is_a?(Structure)

    parent.wegoaudit_structure.has_field?(field_api_name)
  end

  def original_value
    return nil unless parent.is_a?(Structure)

    parent.wegoaudit_structure.calc_field_values
      .fetch(field_api_name, value)
  end

  def value
    calc_convert_value(self[:value])
  end
end
