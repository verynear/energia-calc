class ApplicationUpdateService < BaseServicer
  include AppDelegateTools
  include CDQ

  APPLICATION_CLASSES = [AuditType,
                         StructureType,
                         Grouping,
                         Field,
                         FieldEnumeration,
                         Measure,
                         MeasureValue]
                         # TODO remove MeasureValue, these should only come down as part of an audit

  def execute!
    cdq.background do
      BW::NetworkIndicator.show
      download_application_schema
      download_buildings

      BW::NetworkIndicator.hide
      cdq.contexts.current.save(nil)
      Dispatch::Queue.main.sync { cdq.save }
    end

    true
  end

  def download_application_schema
    APPLICATION_CLASSES.each do |object_class|
      service = RemoteObjectDownloadService.new(object_class: object_class)
      service.execute!
    end
  end

  def download_buildings
      service = RemoteObjectDownloadService.new(object_class: Structure,
                                                index_path: 'buildings')
      service.execute!
  end
end
