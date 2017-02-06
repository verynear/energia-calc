class StructureUploadService < BaseServicer
  include AppDelegateTools
  include CDQ

  attr_accessor :structure

  def execute!
    if RemoteObjectUploadService.execute(object: structure)
      if structure.physical_structure
        RemoteObjectUploadService.execute(object: structure.physical_structure)
      end

      structure.field_values.each do |field_value|
        RemoteObjectUploadService.execute(object: field_value)
      end

      StructureImagesUploadService.execute!(structure: structure)

      structure.substructures.each do |substructure|
        StructureUploadService.execute(structure: substructure)
      end

      structure.sample_groups.each do |sample_group|
        SampleGroupUploadService.execute(sample_group: sample_group)
      end
    end
  end
end
