class StructureDestroyer < BaseServicer
  attr_accessor :local, :structure

  def execute!
    destroy_field_values
    destroy_substructures
    destroy_sample_groups
    destroy_images
    destroy_structure
    true
  end

  private

  def destroy_field_values
    structure.field_values.each do |field_value|
      field_value.destroy(local)
    end
  end

  def destroy_sample_groups
    structure.sample_groups.each do |sample_group|
      SampleGroupDestroyer.execute!(sample_group: sample_group, local: local)
    end
  end

  def destroy_substructures
    structure.substructures.each do |substructure|
      StructureDestroyer.execute!(structure: substructure, local: local)
    end
  end

  def destroy_structure
    structure.physical_structure.destroy(local) if structure.physical_structure
    structure.destroy(local)
  end

  def destroy_images
    structure.structure_images.each do |image|
      StructureImageDestroyer.execute!(image: image, local: local)
    end
  end

  def local
    @local || false
  end
end
