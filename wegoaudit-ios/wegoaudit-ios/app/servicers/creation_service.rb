# This service creates an object in Core Data from a hash. Any parameters
# that have been downloaded are mapped from their wegowise equivalent as
# necessary.
#
# This class does not permanently save the object. That should be done in the
# calling class.
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
    if mapped_parameters.has_key?('id')
      self.object = object_class.create
    else
      self.object = object_class.create_with_uuid
    end
    self.object.set_attributes(mapped_parameters)
  end

  def object_does_not_exist?
    find_object
    return true if @object.nil?
    raise "#{object_class} with #{synchronization_attribute} #{synchronization_value} already exists"
  end
end
