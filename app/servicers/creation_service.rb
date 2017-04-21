# This service creates an object from a hash.
#
# You MUST specify the object_class as one of the parameters.

class CreationService < ObjectServicer
  def execute!
    object_does_not_exist?
    create_object!
    handle_sub_objects
    true
  end

  private

  def create_object!
    self.object = object_class.create!(mapped_parameters)
  end

  def object_does_not_exist?
    find_object
    return true if @object.nil?
    raise "#{object_class} with #{synchronization_attribute} #{synchronization_value} already exists"
  end

  def handle_sub_objects
    @sub_objects.each do |sub_object_params|
      if sub_object_params.keys.length == 1
        sub_object = sub_object_params.values.first
        type_klazz = subobject_type(sub_object)
        service = HandlerService.new(object_class: type_klazz, params: sub_object)
        service.execute!
        if service.object.klazz == @object.physical_structure_type
          @object.physical_structure = service.object
        end
      end
    end
  end

  def subobject_type(sub_object_params)
    return Structure if sub_object_params.has_key?('physical_structure_id')
    return FieldValue if sub_object_params.has_key?('field_id')
    return MeasureValue if sub_object_params.has_key?('measure_id')
    Module.const_get(@object.physical_structure_type)
  end
end
