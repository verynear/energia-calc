class FullStructureDownloadService < BaseServicer
  include AppDelegateTools
  include CDQ

  attr_accessor :clone_into_structure_id,
                :copy_attributes_to,
                :structure_id

  def execute!
    cdq.background do

      service = RemoteObjectDownloadService.new(object_class: Structure,
                                                index_path: path)
      service.execute!
      service.object.full_download_on = Time.now

      cdq.contexts.current.save(nil)
      Dispatch::Queue.main.sync do
        if clone_into_structure_id
          StructureCloneService.execute!(structure: service.object,
                                         params: { parent_structure_id:
                                                    clone_into_structure_id })
        elsif copy_attributes_to
          AttributeCopierService.execute!(
            from: service.object.physical_structure,
            to: copy_attributes_to)
        end
        cdq.save

        NSNotificationCenter
          .defaultCenter
          .postNotificationName('fullStructureDownloadComplete', object: self)
      end
    end
  end

  def path
    "/structures/#{structure_id}/export_full"
  end
end
