class StructureFieldPresenter

  extend ActiveModel::Naming
  include ActiveModel::Conversion

  VALUE_TYPE_PARTIALS = {
    'currency' => 'text_input',
    'date' => 'date_select',
    'decimal' => 'text_input',
    'email' => 'text_input',
    'float' => 'text_input',
    'integer' => 'text_input',
    'phone' => 'text_input',
    'picker' => 'select',
    'state' => 'state',
    'string' => 'text_input',
    'switch' => 'checkbox',
    'text' => 'textarea'
  }

  attr_reader :audit_field,
              :audit_field_value,
              :field_enumeration,
              :audit_structure

  delegate :name,
           :to_param,
           :to_key,
           :value_type,
           :storage_type,
           to: :audit_field

  delegate :value,
           to: :audit_field_value,
           prefix: true,
           allow_nil: true

  delegate :value,
           to: :enumeration_value,
           prefix: true,
           allow_nil: true


  class << self
    def model_name
      AuditField.model_name
    end
  end

  def initialize(audit_structure, audit_field, audit_field_value = nil, string_value = nil)
    @audit_structure = audit_structure
    @audit_field = audit_field
    @audit_field_value = audit_field_value
    @string_value = string_value
  end

  def string_value
    @string_value
  end

  def partial
    "#{VALUE_TYPE_PARTIALS.fetch(value_type, 'text_input')}_field"
  end
end
