class SubstructureMap
  attr_accessor :structure

  def initialize(structure)
    self.structure = structure

    @ordered_keys = []
    @ordered_substructures = []
    @substructures = {}

    child_structure_types.each do |subtype|
      @substructures[subtype.name] = []
      @ordered_keys << subtype.name
      @ordered_substructures << subtype
    end

    sorted_substructures.each do |substructure|
      name = find_section(substructure.structure_type)
      @substructures[name] << substructure
    end

    sorted_sample_groups.each do |sample_group|
      name = find_section(sample_group.structure_type)
      @substructures[name] << sample_group
    end
  end

  def child_structure_types
    structure.structure_type
             .child_structure_types
             .sort_by(&:name)
  end

  def find_section(type)
    return type.name if @substructures[type.name]
    find_section(type.parent_structure_type)
  end

  def sorted_substructures
    structure.substructures.not_destroyed.sort { |a, b| a.name <=> b.name }
  end

  def sorted_sample_groups
    structure.sample_groups.not_destroyed.sort_by(&:name)
  end

  def objectAtIndexPath(indexPath)
    section(indexPath.section)[indexPath.row]
  end

  def removeObjectAtIndexPath(indexPath)
    section(indexPath.section).delete_at(indexPath.row)
  end

  def section(section_index)
    @substructures[section_name(section_index)]
  end

  def section_name(section_index)
    @ordered_keys[section_index]
  end

  def section_count
    @ordered_keys.count
  end

  def substructureForSection(section_index)
    @ordered_substructures[section_index]
  end

  def to_s
    "sections: #{@ordered_keys}"
  end
end
