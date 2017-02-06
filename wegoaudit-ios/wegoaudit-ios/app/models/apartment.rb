class Apartment < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  def name=(new_name)
    self.unit_number = new_name
    self.structure.name = new_name if self.structure
  end

  def name
    self.unit_number
  end

  def short_description
    unit_number
  end

  def structure
    Structure.where(physical_structure_type: 'Apartment',
                    physical_structure_id: self.id)
             .first
  end
end
