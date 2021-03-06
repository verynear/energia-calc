# This class determines if the object must be created or saved and passes the
# actual operation to either the UpdateService or the CreationService.
#
# This class does not permanently save the object. That should be done in the
# calling class.
#
# You MUST specify the object_class as one of the parameters.

class HandlerService < ObjectServicer
  def execute!
    if object_exists?
      if should_be_destroyed?
        @object.destroy
      else
        @service = UpdateService.new(object: @object,
                                     params: params,
                                     object_class: object_class)
      end
    else
      @service = CreationService.new(object_class: object_class, params: params)
    end
    if @service
      @service.execute!
      @object = @service.object
    end
    true
  end

  def synchronization_attribute
    :id
  end

  private

  def object_exists?
    return false unless params[synchronization_attribute.to_s].present?
    @object = object_class.find_by(synchronization_attribute =>
                                     params[synchronization_attribute.to_s])
  end

  def should_be_destroyed?
    params[:destroy_attempt_on].present?
  end
end
