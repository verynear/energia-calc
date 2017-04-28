class StructureDestroyer < BaseServicer
  attr_accessor :audit_structure

  def execute!
    AuditStructure.transaction do
      destroy_field_values
      destroy_sample_groups
      destroy_substructures
      destroy_images
      destroy_structure
    end
  end

  private

  def destroy_field_values
    audit_structure.audit_field_values.destroy_all
  end

  def destroy_sample_groups
    audit_structure.sample_groups.each do |sample_group|
      SampleGroupDestroyer.execute!(sample_group: sample_group)
    end
  end

  def destroy_substructures
    audit_structure.substructures.each do |substructure|
      StructureDestroyer.execute!(audit_structure: substructure)
    end
  end

  def destroy_structure
    audit_structure.physical_structure.destroy if audit_structure.physical_structure
    audit_structure.destroy
  end

  def destroy_images
    audit_structure.structure_images.destroy_all
  end
end
