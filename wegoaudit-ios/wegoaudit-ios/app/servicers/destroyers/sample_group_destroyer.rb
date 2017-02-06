class SampleGroupDestroyer < BaseServicer
  attr_accessor :local,
                :sample_group

  def execute!
    destroy_structures
    sample_group.destroy(local)
    true
  end

  private

  def destroy_structures
    sample_group.substructures.each do |structure|
      StructureDestroyer.execute!(structure: structure, local: local)
    end
  end

  def local
    @local || false
  end
end
