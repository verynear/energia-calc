class SubstructureTypesPresenter
  attr_reader :structure,
              :substructures

  def initialize(structure)
    @structure = structure

    @substructures = {}
    ordered_substructure_types.each do |structure_subtype|
      @substructures[structure_subtype] = []
    end

    ordered_substructures.each do |substructure|
      structure_type = find_section(substructure.structure_type)
      @substructures[structure_type] << substructure
    end

    ordered_sample_groups.each do |sample_group|
      structure_type = find_section(sample_group.structure_type)
      @substructures[structure_type] << sample_group
    end
  end

  private

  def find_section(structure_type)
    return structure_type if substructures.has_key?(structure_type)
    find_section(structure_type.parent_structure_type)
  end

  def ordered_sample_groups
    structure.sample_groups
             .active
             .includes(:structure_type)
             .order(:name)
  end

  def ordered_substructures
    structure.substructures
             .active
             .includes(:physical_structure, :structure_type)
             .order(:name)
  end

  def ordered_substructure_types
    structure.structure_type
             .child_structure_types
             .order(:name)
  end
end
