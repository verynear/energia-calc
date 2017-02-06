class CameraCell < UICollectionViewCell
  def initWithFrame(frame)
    super.tap do
      image_view = UIImageView.alloc.initWithFrame(self.bounds)
      image_view.contentMode = UIViewContentModeCenter
      image_view.image = UIImage.imageNamed('icon-camera.png')

      self.contentView.backgroundColor = "#e8e8e8".to_color
      self.contentView.addSubview(image_view)
    end
  end
end
