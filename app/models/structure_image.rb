class StructureImage < ActiveRecord::Base
  include ImageUploader::Attachment.new(:image) # adds an `image` virtual attribute

  include Cloneable,
          SoftDestruction

  DEFAULT_EXPIRATION_SECONDS = 10

  belongs_to :audit_structure

  alias_method :parent_object, :audit_structure

  def absolute_url(style)
    Retrocalc::BASE_URL + asset.url(style)
  end

  def expiring_url(style)
    asset.expiring_url(DEFAULT_EXPIRATION_SECONDS, style)
  end
end
