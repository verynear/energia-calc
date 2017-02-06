# When you have a CDQ backed object you can use this class as a base for a
# service that can act upon either the individual object or on all of the
# objects.
#
# You MUST specify the object_class as one of the parameters.

class ObjectServicer < BaseServicer
  attr_accessor :errors, :object, :object_class, :params

  def synchronization_attribute
    object_class.synchronization_attribute
  end

  def find_object
    return nil if synchronization_attribute.nil?
    @object = object_class
                .where(synchronization_attribute => synchronization_value)
                .first
  end

  def synchronization_value
    params[synchronization_attribute.to_s]
  end

  def mapped_parameters
    return @mapped_parameters if @mapped_parameters

    # params downloaded from the web will generally be encapsulated in an NSData
    # object. NSData is immutable, so the parameters are copied into a new
    # mutable hash with only the allowed attributes passed in
    @mapped_parameters = {}
    attribute_keys = object_class.attribute_keys - ['created_at', 'updated_at']

    params.each do |key, value|
      next unless attribute_keys.include?(key)
      next if value.is_a?(Hash) || value.is_a?(Array)

      # Convert dates to
      if value.is_a?(String)
        @mapped_parameters[key] = TimeFormatter.from_string("#{value[0..18]}Z") || value
      else
        @mapped_parameters[key] = value
      end
    end
    @mapped_parameters
  end

  def handle_sub_objects
    sub_objects.each do |sub_object_params|
      if sub_object_params.keys.length == 1
        sub_object = sub_object_params.values.first
        type_klazz = subobject_type(sub_object_params.keys.first)
        service = ::HandlerService.new(object_class: type_klazz, params: sub_object)
        service.execute!
        if @object.respond_to?(:physical_structure_type) &&
           service.object.klazz == @object.physical_structure_type
          @object.physical_structure = service.object
        end
      end
    end
  end

  def sub_objects
    return @sub_objects if @sub_objects

    @sub_objects = []
    params.each do |key, value|
      if value.is_a?(Hash)
        @sub_objects << { key => value }
      elsif value.is_a?(Array)
        value.each do |val|
          @sub_objects << { key => val }
        end
      end
    end
    @sub_objects
  end

  def object_key
    @object_key ||= object_class.name.underscore
  end

  def class_name
    @target_class_name ||= object_class.name.split('_').first
  end

  def object_class
    return @object_class if @object_class
    return @object.class if @object
    raise 'Unable to determine object_class'
  end

  def subobject_type(key)
    case key.to_s
    when 'field_values' then FieldValue
    when 'sample_groups' then SampleGroup
    when 'structure_images' then StructureImage
    when 'substructures' then Structure
    else
      Module.const_get(object.physical_structure_type)
    end
  end
end
