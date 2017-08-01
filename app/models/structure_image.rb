class StructureImage < ActiveRecord::Base
  include ImageUploader::Attachment.new(:image) # adds an `image` virtual attribute

  validates :image_data, presence: { message: "Image data missing" }

  include Cloneable,
          SoftDestruction

  DEFAULT_EXPIRATION_SECONDS = 10

  belongs_to :audit_structure

  alias_method :parent_object, :audit_structure


  def remote_name
  end

  def photo_path
    self.read_attribute(:photo_path)
  end
end
