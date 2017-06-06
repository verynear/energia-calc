class StructureImage < ActiveRecord::Base
  include Cloneable,
          SoftDestruction

  DEFAULT_EXPIRATION_SECONDS = 10

  belongs_to :audit_structure

  has_attached_file :asset,
    styles: {
      thumb: '150x150#',
      medium: '800x800>'
    }

  process_in_background :asset

  validates :file_name, presence: true
  validates_attachment_content_type :asset,
                                    content_type: %w[image/jpg image/jpeg image/png]

  alias_method :parent_object, :audit_structure

  def absolute_url(style)
    Retrocalc::BASE_URL + asset.url(style)
  end

  def expiring_url(style)
    asset.expiring_url(DEFAULT_EXPIRATION_SECONDS, style)
  end
end
