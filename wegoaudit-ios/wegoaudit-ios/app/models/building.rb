class Building < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :uncloned, where(cloned: false)
  scope :wegowise, where('wegowise_id != nil')

  def name=(new_name)
    self.nickname = new_name
    self.structure.name = new_name if self.structure
  end

  def name
    self.nickname
  end

  def linked?
    wegowise_id != 0
  end

  def short_description
    desc = []
    desc << building_type.capitalize  if building_type
    (desc + [nickname]).compact.join(' - ')
  end

  def search_result_description
    desc = [street_address, city, state_code]
    desc.unshift(nickname) if nickname != street_address
    desc.join(', ')
  end

  def self.find_all_by_name(search_name)
    uncloned
      .wegowise
      .where('nickname CONTAINS[cd] %@', search_name)
      .sort_by(:nickname)
  end

  def structure
    Structure.where(physical_structure_type: 'Building',
                    physical_structure_id: self.id)
             .first
  end
end
