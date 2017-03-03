class StructureFieldPresenter
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

  attr_reader :field,
              :field_value,
              :field_enumeration,
              :structure

  delegate :name,
           :to_param,
           :to_key,
           :value_type,
           to: :field

  delegate :value,
           to: :field_value,
           prefix: true,
           allow_nil: true

  delegate :value,
           to: :enumeration_value,
           prefix: true,
           allow_nil: true


  class << self
    def model_name
      Field.model_name
    end

    def f_enumerations
      FieldEnumeration.where(field_id: field.id)
    end
  end

  

  def initialize(structure, field, field_value = nil, string_value = nil)
    @structure = structure
    @field = field
    @field_value = field_value
    @string_value = string_value
  end

  def string_value
    @string_value
  end

  def partial
    "#{VALUE_TYPE_PARTIALS.fetch(value_type, 'text_input')}_field"
  end
end
