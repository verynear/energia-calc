class SampleGroupCreationService < BaseServicer
  attr_accessor :params,
                :parent_structure,
                :sample_group,
                :structure_type

  def execute!
    @sample_group = SampleGroup.create_with_uuid(
      name: name,
      n_structures: n_structures,
      structure_type_id: structure_type.id,
      parent_structure_id: parent_structure_id)
  end

  private

  def parent_structure_id
    parent_structure && parent_structure.id || params[:parent_structure_id]
  end

  def name
    params[:name]
  end

  def n_structures
    params[:n_structures].to_i
  end
end
