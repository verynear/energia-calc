# This service updates an object.
#
# You MUST specify the object_class as one of the parameters.

class UpdateService < ObjectServicer
  def execute!
    if object_exists?
      @object.update_attributes(mapped_parameters)
      handle_sub_objects
      true
    else
      false
    end
  end

  private

  def object_exists?
    find_object
    return true if @object
    raise "#{object_class.to_s} with #{synchronization_attribute} #{synchronization_value} not found"
  end

  def handle_sub_objects
    @sub_objects.each do |sub_object_params|
      if sub_object_params.keys.length == 1
        sub_object = sub_object_params.values.first
        type_klazz = subobject_type(sub_object_params.keys.first)
        service = HandlerService.new(object_class: type_klazz, params: sub_object)
        service.execute!
        if service.object.klazz == @object.physical_structure_type
          @object.physical_structure = service.object
          @object.save!
        end
      end
    end
  end

  def subobject_type(key)
    key = key.to_s
    return Structure if key == 'substructures'
    return AuditFieldValue if key == 'audit_field_values'
    Module.const_get(@object.physical_structure_type)
  end
end
