class StructureImage < ActiveRecord::Base
  include ImageUploader::Attachment.new(:image) # adds an `image` virtual attribute

  include Cloneable,
          SoftDestruction

  DEFAULT_EXPIRATION_SECONDS = 10

  belongs_to :audit_structure

  alias_method :parent_object, :audit_structure

  def absolute_url(style)
    Retrocalc::BASE_URL + image.url(style)
  end

  def expiring_url(style)
    image.expiring_url(DEFAULT_EXPIRATION_SECONDS, style)
  end

  def remote_name
  end
end
