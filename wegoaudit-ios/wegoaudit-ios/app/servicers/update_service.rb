# This service updates an object in Core Data from a hash. Any parameters
# that have been downloaded are mapped from their wegowise equivalent as
# necessary.
#
# This class does not permanently save the object. That should be done in the
# calling class.
#
# You MUST specify the object_class as one of the parameters.

class UpdateService < ObjectServicer
  def execute!
    find_object unless @object
    object_exists?
    @object.set_attributes(mapped_parameters)
    handle_sub_objects
    prune_missing_sub_objects

    true
  end

  private

  def object_exists?
    return true if @object
    raise "#{object_class.to_s} with #{synchronization_attribute} #{synchronization_value} not found"
  end

  # Destroy any sub-structures and sample groups that were not downloaded from
  # the server. They must have been destroyed from the web UI, and should be
  # destroyed locally as well.
  def prune_missing_sub_objects
    if object.respond_to?(:substructures) && params.has_key?('substructures')
      (object.substructures.map(&:id) - sub_object_ids('substructures')).each do |id|
        structure = Structure.where(id: id).first
        StructureDestroyer.execute!(structure: structure, local: true)
      end
    end

    if object.respond_to?(:sample_groups) && params.has_key?('sample_groups')
      (object.sample_groups.map(&:id) - sub_object_ids('sample_groups')).each do |id|
        sample_group = SampleGroup.where(id: id).first
        SampleGroupDestroyer.execute!(sample_group: sample_group, local: true)
      end
    end

    if object.respond_to?(:structure_images) && params.has_key?('structure_images')
      (object.structure_images.map(&:id) - sub_object_ids('structure_images')).each do |id|
        image = StructureImage.where(id: id).first
        StructureImageDestroyer.execute!(image: image, local: true)
      end
    end
  end

  def sub_object_ids(key)
    sub_objects.select { |sub_object| sub_object.keys == [key] }
               .map(&:values)
               .flatten
               .map { |sub_object| sub_object['id'] }
  end
end
