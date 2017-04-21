class SampleGroupCloneService < BaseServicer
  attr_accessor :params,
                :sample_group

  attr_reader :cloned_sample_group

  def execute!
    @params ||= {}
    clone_sample_group
    clone_substructures
  end

  private

  def clone_sample_group
    @cloned_sample_group = sample_group.create_clone(params)
  end

  def clone_substructures
    sample_group.substructures.each do |substructure|
      StructureCloneService.execute!(
        params: { sample_group_id: cloned_sample_group.id },
        structure: substructure
      )
    end
  end
end
