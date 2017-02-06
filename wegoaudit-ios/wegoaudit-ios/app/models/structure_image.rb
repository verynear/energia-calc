class StructureImage < CDQManagedObject
  include CDQRecord

  def structure
    @structure ||= Structure.where(id: structure_id).first
  end

  def thumbnail_path
    "#{file_path}-thumb.jpg"
  end

  def original_path
    "#{file_path}.jpg"
  end

  private

  def file_path
    "#{App.documents_path}/#{structure_id} - #{id}"
  end
end
