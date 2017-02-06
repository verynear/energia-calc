# This class handles uploading all of the StructureImage files for a Structure.
# It will wait for all of the images to finish uploading before saving the CDQ
# context.
class StructureImagesUploadService < BaseServicer
  include CDQ

  attr_accessor :structure

  def initialize(*args)
    @save_needed = false
    super(*args)
  end

  def execute!
    structure.structure_images.each do |image|
      with_network_indicator do
        @save_needed |= upload(image)
      end
    end

    cdq.save if @save_needed
  end

  private

  def upload(image)
    service = PhotoUploadService.new(image: image)
    service.execute!
    service.changed?
  end

  def with_network_indicator
    BW::NetworkIndicator.show
    yield
    BW::NetworkIndicator.hide
  end
end
