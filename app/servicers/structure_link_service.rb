class StructureLinkService < BaseServicer
  attr_accessor :physical_structure,
                :structure

  def execute!
    structure.physical_structure.update(physical_structure.cloneable_attributes)
  end
end
