class StructureCloneService < BaseServicer
  attr_accessor :cloned_structure,
                :params,
                :structure

  def execute!
    @params = @params || {}
    clone_structure
    clone_physical_structure
    copy_field_values
    clone_sample_groups
    clone_substructures
  end

  def clone_structure
    @cloned_structure = structure.clone(params)
  end

  def clone_physical_structure
    return unless structure.physical_structure
    @physical_structure = structure.physical_structure.clone
    @physical_structure.name = cloned_structure.name
    @cloned_structure.physical_structure_id = @physical_structure.id
  end

  def copy_field_values
    structure.field_values.each do |field_value|
      field_value.clone(structure_id: @cloned_structure.id)
    end
  end

  def clone_sample_groups
    structure.sample_groups.each do |sample_group|
      SampleGroupCloneService.execute!(
        sample_group: sample_group,
        params: { parent_structure_id: cloned_structure.id })
    end
  end

  def clone_substructures
    structure.substructures.each do |substructure|
      StructureCloneService.execute!(structure: substructure,
        params: { parent_structure_id: @cloned_structure.id })
    end
  end

  def structure_type
    structure.structure_type
  end
end
