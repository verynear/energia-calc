class PhotoCell < UICollectionViewCell
  attr_accessor :image_view

  def image=(file_path)
    return unless File.exist?(file_path)
    self.image_view.image = UIImage.imageWithContentsOfFile(file_path)
  end

  def initWithFrame(frame)
    super.tap do
      self.image_view = UIImageView.alloc.initWithFrame(self.bounds)
      image_view.contentMode = UIViewContentModeScaleAspectFit
      image_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      image_view.userInteractionEnabled = true

      contentView.autoresizesSubviews = true
      contentView.addSubview(image_view)
    end
  end
end
