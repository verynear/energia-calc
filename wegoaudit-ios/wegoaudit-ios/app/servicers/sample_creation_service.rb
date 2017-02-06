# Creates a single structure within a Sample Group.
class SampleCreationService < BaseServicer
  attr_accessor :params,
                :sample_group,
                :structure,
                :structure_type

  def execute!
    create_sample
  end

  def create_sample
    @structure = Structure.create_with_uuid(structure_params)
  end

  def sample_group_id
    sample_group.id if sample_group
  end

  def structure_params
    params.merge(
      structure_type_id: structure_type.id,
      sample_group_id: sample_group_id
    )
  end
end

