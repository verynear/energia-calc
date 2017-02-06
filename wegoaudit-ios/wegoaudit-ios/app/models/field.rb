class Field < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :sort_display_order, sort_by(:display_order)

  STRING_TYPES = ['text', 'string', 'phone', 'email', 'picker', 'state']
  FLOAT_TYPES = ['float']
  DECIMAL_TYPES = ['decimal', 'currency']
  INTEGER_TYPES = ['integer']
  NUMBER_TYPES = FLOAT_TYPES + DECIMAL_TYPES + INTEGER_TYPES

  STATE_CODES = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA
                   KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ
                   NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT
                   VA WA WV WI WY]

  def form
    hash = base_form
    hash.merge!(items: enumeration_values) if picker?
    hash.merge!(items: STATE_CODES) if state?
    if text?
      hash.merge!(row_height: 100)
    end
    hash
  end

  def picker?
    value_type == 'picker'
  end

  def date?
    value_type == 'date'
  end

  def state?
    value_type == 'state'
  end

  def text?
    value_type == 'text'
  end

  def enumeration_values
    return nil unless picker?
    field_enumerations.sort_by(:display_order).map(&:value)
  end

  def grouping
    @grouping ||= Grouping.where(id: grouping_id).first
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

  def convert_value(val)
    case storage_type
    when 'string_value' then val.to_s
    when 'float_value' then val.to_f
    when 'decimal_value' then BigDecimal.new(val)
    when 'integer_value' then val.to_i
    when 'date_value' then NSDate.dateWithTimeIntervalSince1970(val)
    when 'boolean_value' then val
    end
  end

  def field_enumerations
    FieldEnumeration.where(field_id: id)
  end

  private

  def base_form
    { title: name,
      type: normalized_type,
      placeholder: placeholder_value,
      input_accessory: :done,
      key: id }
  end

  def placeholder_value
    return placeholder if placeholder
    case value_type
    when 'text', 'string' then ''
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
                         when 'state' then 'picker'
                         else
                           value_type
                         end
  end
end
