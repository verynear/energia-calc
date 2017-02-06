class StructureDestroyer < BaseServicer
  attr_accessor :structure

  def execute!
    Structure.transaction do
      destroy_field_values
      destroy_sample_groups
      destroy_substructures
      destroy_images
      destroy_structure
    end
  end

  private

  def destroy_field_values
    structure.field_values.destroy_all
  end

  def destroy_sample_groups
    structure.sample_groups.each do |sample_group|
      SampleGroupDestroyer.execute!(sample_group: sample_group)
    end
  end

  def destroy_substructures
    structure.substructures.each do |substructure|
      StructureDestroyer.execute!(structure: substructure)
    end
  end

  def destroy_structure
    structure.physical_structure.destroy if structure.physical_structure
    structure.destroy
  end

  def destroy_images
    structure.structure_images.destroy_all
  end
end
