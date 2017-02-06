# When you have a ActiveRecord backed object you can use this class as a base for a
# service that can act upon either the individual object or on all of the
# objects.
#
# You MUST specify the object_class as one of the parameters.

class ObjectServicer < BaseServicer
  attr_accessor :errors, :object, :object_class, :params

  def synchronization_attribute
    :id
  end

  def find_object
    @object = object_class
                .find_by(synchronization_attribute => synchronization_value)
  end

  def synchronization_value
    params[synchronization_attribute.to_s]
  end

  def mapped_parameters
    return @mapped_parameters if @mapped_parameters
    extract_sub_objects
    @mapped_parameters = params
  end

  def object_key
    @object_key ||= object_class.name.underscore
  end

  def class_name
    @target_class_name ||= object_class.name
  end

  def object_class
    return @object_class if @object_class
    return @object.class if @object
    raise 'Unable to determine object_class'
  end

  private

  def extract_sub_objects
    @sub_objects = []
    params.keys.each do |key|
      value = params.fetch(key)
      if value.is_a?(Hash)
        params.delete(key)
        @sub_objects << { key => value }
      elsif value.is_a?(Array)
        params.delete(key)
        value.each do |val|
          @sub_objects << { key => val }
        end
      end
    end
  end
end
