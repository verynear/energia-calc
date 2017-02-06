class CameraController < UIViewController
  include BaseController

  attr_accessor :structure

  def viewDidLoad
    super

    if Device.camera.rear?
      Device.camera.rear.picture(media_types: [:image]) do |result|
        unless result[:error]
          PhotoSaverService.execute!(structure: structure,
                                     image: result[:original_image])
        end
        self.navigationController.popViewControllerAnimated(self)
      end
    else
      App.alert('You need a camera...')
    end
  end
end
