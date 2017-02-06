class StructureType < CDQManagedObject
  include CDQRecord

  synchronization_attribute :id

  scope :name_order, sort_by(:name)

  def groupings
    Grouping.where(structure_type_id: subtype_id)
            .sort_by(:display_order)
  end

  def form
    { sections: groupings.map { |g| g.form } }
  end

  def self.audit
    where(name: 'Audit').first
  end

  def can_have_substructures?
    child_structure_types.count > 0
  end

  def has_physical_structure?
    !physical_structure_type.nil?
  end

  def is_subtype?
    !parent_structure_type_id.nil? && parent_structure_type.primary == 0
  end

  def structures
    st_ids = child_structure_types.map(&:id)
    Structure.where('structure_type_id in %@', [self.id] + st_ids)
  end

  def find_all_by_name(search_name)
    if physical_structure_type
      physical_structure_class.find_all_by_name(search_name)
    else
      structures.where("name CONTAINS[cd] %@", search_name)
    end
  end

  def uncloned_count
    if physical_structure_type
      physical_structure_class.uncloned.wegowise.count
    else
      structures.count
    end

  end

  def physical_structure_class
    return nil unless physical_structure_type
    Module.const_get(physical_structure_type.to_sym)
  end

  def subtype_id
    return @subtype_id if @subtype_id
    @subtype_id = primary == 1 ? id : parent_structure_type_id
  end

  def parent_structure_type
    return nil unless parent_structure_type_id
    StructureType.where(id: parent_structure_type_id).first
  end

  def child_structure_types
    StructureType.where(parent_structure_type_id: id)
                 .sort_by(:display_order)
  end
end
