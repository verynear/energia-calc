class SampleGroupCloneService < BaseServicer
  attr_accessor :cloned_sample_group,
                :params,
                :sample_group

  def execute!
    @params ||= {}
    clone_sample_group
    clone_substructures
  end

  def clone_sample_group
    @cloned_sample_group = sample_group.clone(params)
  end

  def clone_substructures
    sample_group.substructures.each do |substructure|
      StructureCloneService.execute!(
        structure: substructure,
        params: { sample_group_id: @cloned_sample_group.id })
    end
  end
end
