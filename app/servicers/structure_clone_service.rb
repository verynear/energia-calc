class StructureCloneService < BaseServicer
  attr_accessor :params,
                :structure

  attr_reader :cloned_structure

  def execute!
    @params ||= {}
    clone_structure
    clone_physical_structure
    clone_field_values
    clone_sample_groups
    clone_substructures
  end

  private

  def clone_field_values
    structure.audit_field_values.each do |audit_field_value|
      audit_field_value.create_clone(structure_id: cloned_structure.id)
    end
  end

  def clone_physical_structure
    return unless structure.physical_structure

    cloned_physical_structure = structure.physical_structure.create_clone(
      name: cloned_structure.name
    )
    cloned_structure.update(physical_structure: cloned_physical_structure)
  end

  def clone_sample_groups
    structure.sample_groups.each do |sample_group|
      SampleGroupCloneService.execute!(
        sample_group: sample_group,
        params: { parent_structure_id: cloned_structure.id }
      )
    end
  end

  def clone_structure
    @cloned_structure = structure.create_clone(params)
  end

  def clone_substructures
    structure.substructures.each do |substructure|
      StructureCloneService.execute!(
        params: { parent_structure_id: cloned_structure.id },
        structure: substructure
      )
    end
  end
end
