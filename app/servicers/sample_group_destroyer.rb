class SampleGroupDestroyer < BaseServicer
  attr_accessor :sample_group

  def execute!
    SampleGroup.transaction do
      destroy_substructures
      destroy_sample_group
    end
  end

  private

  def destroy_sample_group
    sample_group.destroy
  end

  def destroy_substructures
    sample_group.substructures.each do |audit_structure|
      StructureDestroyer.execute!(audit_structure: audit_structure)
    end
  end
end
