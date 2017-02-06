module CDQRecord
  def self.included(base)
    base.extend(PublicClassMethods)
  end

  def klazz
    entity.name
  end

  def clone(params = {})
    self.class.create_with_uuid(cloneable_attributes(params))
  end

  def cloneable_attributes(params = {})
    params['cloned'] = true if respond_to?(:cloned)
    attributes.except(*excluded_attributes).merge(params)
  end

  def excluded_attributes
    [
      synchronization_attribute.to_s,
      'successful_upload_on',
      'upload_attempt_on',
      'created_at',
      'updated_at'
    ]
  end

  def destroy(local_destroy = false)
    if local_destroy || !has_been_uploaded?
      super()
      NSLog("#{klazz} with id #{id} was locally destroyed")
    else
      self.destroy_attempt_on = Time.now
      NSLog("#{klazz} with id #{id} was queued for destruction")
    end
    self
  end

  def should_be_destroyed?
    return false unless respond_to?(:destroy_attempt_on)
    self.destroy_attempt_on != nil
  end

  def set_attributes(attrs = {})
    attrs.each do |key, val|
      set_attribute(key, val)
    end
  end

  def set_attribute(attribute_name, val)
    val = convert_static_value(attribute_name.to_s, val)
    send("#{attribute_name}=", val)
  end

  def convert_static_value(attribute_name, val)
    attribute_type = get_attribute_type(attribute_name.to_s)
    raise "Unknown attribute '#{attribute_name}'" if attribute_type.nil?
    case attribute_type
    when NSInteger16AttributeType, NSInteger32AttributeType, NSInteger64AttributeType then val.to_i
    when NSDecimalAttributeType
      unless val.nil?
        BigDecimal.new(val)
      end
    when NSFloatAttributeType then val.to_f
    when NSDateAttributeType
      if val.is_a?(String)
        TimeFormatter.from_string(val)
      elsif val.is_a?(Numeric)
        NSDate.dateWithTimeIntervalSince1970(val)
      else
        val
      end
    when NSBooleanAttributeType
      if val.is_a?(String)
        val.downcase == 'true'
      else
        val
      end
    else
      val
    end
  end

  def get_attribute_type(attribute_name)
    return attribute_types[attribute_name.to_s]
  end

  def attribute_types
    @attribute_types ||= entity.attributesByName.each_with_object({}) do |entry, h|
      h[entry[0]] = entry[1].attributeType
      h
    end
  end

  def attributes
    return @attributes unless @attributes.nil?
    @attributes = {}
    entity.attributesByName.each do |name, desc|
      @attributes[name] = public_send(name)
    end
    @attributes
  end

  def nil_or_empty?(val)
    return true if val.nil?
    return false if [TrueClass, FalseClass].include?(val.class)
    return true if !val.is_a?(String) || val.length == 0
    false
  end

  def has_been_uploaded?
    respond_to?(:successful_upload_on) && !successful_upload_on.nil?
  end

  module PublicClassMethods
    def get_uuid
      NSUUID.UUID.UUIDString.downcase
    end

    def create_with_uuid(params = {})
      create(params.merge(id: get_uuid))
    end

    def attribute_keys
      entity_description.attributesByName.keys
    end

    def synchronization_attribute(attr)
      define_method :synchronization_attribute do
        attr
      end

      define_singleton_method :synchronization_attribute do
        attr
      end
    end

    def klazz
      entity_description.name
    end

    def file_location
      context.persistentStoreCoordinator.persistentStores.first.URL.absoluteString
    end
  end
end
