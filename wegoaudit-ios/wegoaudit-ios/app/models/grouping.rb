class Grouping < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  def structure_type
    StructureType.where(id: structure_type_id).first
  end

  def fields
    Field.where(grouping_id: id)
  end
end
