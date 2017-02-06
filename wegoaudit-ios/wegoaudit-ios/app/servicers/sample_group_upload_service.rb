class SampleGroupUploadService < BaseServicer
  attr_accessor :sample_group

  def execute!
    RemoteObjectUploadService.execute(object: sample_group)

    sample_group.substructures.each do |structure|
      StructureUploadService.execute(structure: structure)
    end
  end
end
