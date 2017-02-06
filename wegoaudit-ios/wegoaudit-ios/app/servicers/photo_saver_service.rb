class PhotoSaverService < BaseServicer
  include CDQ

  attr_accessor :image,
                :structure

  ORIGINAL_QUALITY = 1.0
  THUMB_QUALITY = 0.5
  THUMB_SIZE = [125, 125]

  def execute!
    structure_image = create_structure_image!

    original = UIImageJPEGRepresentation(image, ORIGINAL_QUALITY)
    original.writeToFile(structure_image.original_path, atomically: true)

    thumb = UIImageJPEGRepresentation(image.scale_to(THUMB_SIZE), THUMB_QUALITY)
    thumb.writeToFile(structure_image.thumbnail_path, atomically: true)
  end

  private

  def create_structure_image!
    # Create a new StructureImage in the database. This will determine
    # what the file_path is going to be.
    StructureImage.create_with_uuid(structure_id: structure.id).tap do
      cdq.save
    end
  end
end
