module RemoteObjectProcessing
  def process_object(klazz, params)
    service = HandlerService.new(object_class: klazz,
                                 params: params)
    service.execute!
    object = service.object

    if object.valid? && !object.destroyed?
      object.update_attribute(:successful_upload_on, object.upload_attempt_on)
    end

    object
  end
end
