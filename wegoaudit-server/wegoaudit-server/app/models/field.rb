class Field < ActiveRecord::Base
  include ApiNameGeneration

  before_create :generate_api_name

  belongs_to :grouping
  has_many :field_values
  has_many :field_enumerations

  validates :name, presence: true
  validates :value_type, presence: true
  validates :display_order, presence: true,
                            uniqueness: { scope: :grouping_id }

  validate :validate_unchanged_api_name

  scope :sort_display_order, order(:display_order)

  STRING_TYPES = ['text', 'string', 'phone', 'email', 'picker', 'state']
  FLOAT_TYPES = ['float']
  DECIMAL_TYPES = ['decimal', 'currency']
  INTEGER_TYPES = ['integer']
  NUMBER_TYPES = FLOAT_TYPES + DECIMAL_TYPES + INTEGER_TYPES

  def form
    hash = base_form
    hash.merge!(items: field_enumerations) if picker?
    hash
  end

  def picker?
    value_type == 'picker'
  end

  def date?
    value_type == 'date'
  end

  def field_enumerations
    return nil unless picker?
    @field_enumeration = FieldEnumeration.where(field_id: field.id)
  end

  def grouping
    @grouping ||= Grouping.where(id: grouping_id)
  end

  def storage_type
    @storage_type ||= case value_type
                    when *STRING_TYPES then 'string_value'
                    when *FLOAT_TYPES then 'float_value'
                    when *DECIMAL_TYPES then 'decimal_value'
                    when *INTEGER_TYPES then 'integer_value'
                    when 'date' then 'date_value'
                    when 'switch' then 'boolean_value'
                    end
  end

  private

  def base_form
    { title: name,
      type: normalized_type,
      placeholder: placeholder_value,
      key: id }
  end

  def placeholder_value
    return placeholder if placeholder
    case value_type
    when 'text', 'string' then 'name'
    when 'phone' then '123-456-7890'
    when 'email' then 'test@example.com'
    when 'float', 'decimal' then '1.23456'
    when 'currency' then '12.51'
    when 'integer' then '234'
    end
  end

  def normalized_type
    @normalized_type ||= case value_type
                         when *NUMBER_TYPES then 'number'
                         else
                           value_type
                         end
  end
end
