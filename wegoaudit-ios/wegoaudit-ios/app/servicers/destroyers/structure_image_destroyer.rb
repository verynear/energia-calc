# This class handles destruction of StructureImage records. It should delete
# any associated image files (thumbnails, originals) before destroying the
# CoreData record.
class StructureImageDestroyer < BaseServicer
  attr_accessor :image, :local

  def execute!
    unlink_path(image.original_path)
    unlink_path(image.thumbnail_path)
    image.destroy(local)
  end

  def local
    @local || false
  end

  private

  def unlink_path(path)
    File.unlink(path) if File.exist?(path)
  end
end
