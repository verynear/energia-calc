module Retrocalc
  class PhotosJsonPresenter
    include Rails.application.routes.url_helpers

    attr_accessor :parent_structure

    def initialize(parent_structure)
      self.parent_structure = parent_structure
    end

    def as_json
      photos = parent_structure.structure_images
      photos.map { |photo| photo_json(photo) }
    end

    private

    def absolute_url(photo, size)
      Retrocalc::BASE_URL +
        download_audit_photo_path(parent_audit, photo, size: size)
    end

    def parent_audit
      @parent_audit ||= parent_structure.parent_audit
    end

    def photo_json(photo)
      {
        id: photo.id,
        thumb_url: absolute_url(photo, :thumb),
        original_url: absolute_url(photo, :original)
      }
    end
  end
end
