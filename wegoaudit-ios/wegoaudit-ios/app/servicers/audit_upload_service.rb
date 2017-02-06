class AuditUploadService < BaseServicer
  include AppDelegateTools
  include CDQ

  attr_accessor :audit

  def execute!
    Dispatch::Queue.concurrent.async do
      cdq.setup

      if RemoteObjectUploadService.execute(object: audit)
        StructureUploadService.execute(structure: audit.structure)
        upload_measure_values
      end

      Dispatch::Queue.main.sync { cdq.save }
    end

    true
  end

  def upload_measure_values
    audit.measure_values.each do |measure_value|
      RemoteObjectUploadService.execute(object: measure_value)
    end
  end
end
