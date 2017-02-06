class Meter < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  def name=(new_name)
    self.account_number = new_name
    self.structure.name = new_name if self.structure
  end

  def name
    self.account_number
  end

  def short_description
    [data_type, account_number].compact.join(' - ')
  end

  def structure
    Structure.where(physical_structure_type: 'Meter',
                    physical_structure_id: self.id)
             .first
  end
end
