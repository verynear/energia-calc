class PhotoController < UIViewController
  attr_accessor :file_path

  def viewDidLoad
    self.view.backgroundColor = UIColor.blackColor

    image_view = UIImageView.alloc.initWithFrame(self.view.bounds)
    image_view.image = scaled_image
    view.addSubview(image_view)

    image_view.when_tapped do
      dismiss_photo
    end
  end

  def prefersStatusBarHidden
    true
  end

  private

  def scaled_image
    @image ||= UIImage.imageWithContentsOfFile(file_path)
                      .scale_to(view.bounds.size)
  end

  def dismiss_photo
    presentingViewController
      .dismissViewControllerAnimated(true, completion: nil)
  end
end
