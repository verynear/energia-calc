class StructureLinkService < BaseServicer
  attr_accessor :physical_structure,
                :audit_structure

  def execute!
    audit_structure.physical_structure.update(physical_structure.cloneable_attributes)
  end
end
