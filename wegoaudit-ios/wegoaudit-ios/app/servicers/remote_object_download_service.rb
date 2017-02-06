# This service downloads all of the specified object types and creates/updates
# as necessary. It utilizes a semaphore to pause execution of the thread until
# the results have been handled.
#
# This service should not be used on the main thread as it will pause the UI.
#
# You MUST specify the object_class as one of the parameters.

class RemoteObjectDownloadService < ObjectServicer
  include AppDelegateTools
  attr_accessor :index_path, :object

  def execute!
    raise 'object_class must be defined' if object_class.nil?

    @semaphore = Dispatch::Semaphore.new(0)
    client.get(index_path) do |result|
      if result.success?
        @result = result
      else
        full_url = result.task.originalRequest.URL.absoluteString
        NSLog("Unable to load #{class_name} from #{full_url} - error => #{result.error.userInfo}")
      end
      @semaphore.signal
    end
    @semaphore.wait
    handle_result
  end

  def index_path
    return @index_path if @index_path

    if object_class.respond_to?(:index_path)
      @index_path = object_class.index_path
    else
      @index_path = "#{class_name.underscore}s"
    end
  end

  def handle_result
    return unless @result

    @result.object.each do |object_params|
      service = HandlerService.new(object_class: object_class,
                                   params: object_params)
      service.execute!
      self.object = service.object
    end
  end
end
