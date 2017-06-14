class SubstructureTypesPresenter
  attr_reader :audit_structure,
              :substructures

  def initialize(audit_structure)
    @audit_structure = audit_structure

    @substructures = {}
    ordered_substructure_types.each do |structure_subtype|
      @substructures[structure_subtype] = []
    end

    ordered_substructures.each do |substructure|
      audit_strc_type = find_section(substructure.audit_strc_type)
      @substructures[audit_strc_type] << substructure
    end

    ordered_sample_groups.each do |sample_group|
      audit_strc_type = find_section(sample_group.audit_strc_type)
      @substructures[audit_strc_type] << sample_group
    end
  end

  private

  def find_section(audit_strc_type)
    return audit_strc_type if substructures.has_key?(audit_strc_type)
    find_section(audit_strc_type.parent_structure_type)
  end

  def ordered_sample_groups
    audit_structure.sample_groups
             .active
             .includes(:audit_strc_type)
             .order(:name)
  end

  def ordered_substructures
    audit_structure.substructures
             .active
             .includes(:physical_structure, audit_strc_type: [:parent_structure_type])
             .order(:name)
  end

  def ordered_substructure_types
    audit_structure.audit_strc_type
             .child_structure_types
             .order(:name)
  end
end