# This service uploads the specified object and updates the object with the
# response. It utilizes a semaphore to pause execution of the thread until
# the results have been handled.
#
# This service should not be used on the main thread as it will pause the UI.
#
# You MUST specify the object as one of the parameters.
class RemoteObjectUploadService < ObjectServicer
  include AppDelegateTools

  def execute!
    raise 'object must be defined' if object.nil?

    @semaphore = Dispatch::Semaphore.new(0)
    client.send(upload_method, upload_path, object_params) do |result|
      if result.success?
        service = HandlerService.new(object_class: object_class,
                                     params: result.object)
        service.execute!
      else
        full_url = result.task.originalRequest.URL.absoluteString
        NSLog("Unable to load #{class_name} from #{full_url} - error => #{result.error.userInfo}")
      end
      @semaphore.signal
    end
    @semaphore.wait
  end

  def object_params
    { "#{class_name.underscore}" => object.attributes.merge(upload_attempt_on: Time.now),
      id: synchronization_value }
  end

  def upload_path
    return update_path if remote_object_exists?
    create_path
  end

  def update_path
    "#{class_name.underscore}s/#{synchronization_value}"
  end

  def synchronization_value
    object.send(synchronization_attribute)
  end

  def create_path
    return object_class.index_path if object_class.respond_to?(:index_path)
    "#{class_name.underscore}s"
  end

  def upload_method
    return :put if remote_object_exists?
    :post
  end

  def remote_object_exists?
    object.successful_upload_on != nil
  end
end
