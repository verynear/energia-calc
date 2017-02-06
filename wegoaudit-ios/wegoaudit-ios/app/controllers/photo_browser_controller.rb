class PhotoBrowserController < UICollectionViewController
  extend IB
  include BaseController

  # Photo cell attributes
  CAMERA_IDENTIFIER = 'Photo Cell'
  PHOTO_IDENTIFIER = 'Camera Cell'
  WIDTH = 125
  HEIGHT = 125

  attr_reader :photos

  def viewDidLoad
    super

    # Configure UICollectionView Cell and Layout
    collectionView.registerClass(PhotoCell,
                                 forCellWithReuseIdentifier: PHOTO_IDENTIFIER)
    collectionView.registerClass(CameraCell,
                                 forCellWithReuseIdentifier: CAMERA_IDENTIFIER)
    collectionView.collectionViewLayout.itemSize = CGSize.new(WIDTH, HEIGHT)
    collectionView.collectionViewLayout.minimumInteritemSpacing = 5
    collectionView.collectionViewLayout.minimumLineSpacing = 5
    collectionView.collectionViewLayout.sectionInset = [10, 10, 0, 10]

    collectionView.backgroundColor = UIColor.whiteColor
  end

  def viewWillAppear(animated)
    super

    @photos = structure_images.select do |image|
      File.exist?(image.thumbnail_path)
    end
    collectionView.reloadData
  end

  def collectionView(view, numberOfItemsInSection: section)
    photos.length + offset
  end

  def collectionView(view, cellForItemAtIndexPath: path)
    if path.item == 0 && can_edit_current_audit?
      cell = view.dequeueReusableCellWithReuseIdentifier(CAMERA_IDENTIFIER, forIndexPath: path)
    else
      cell = view.dequeueReusableCellWithReuseIdentifier(PHOTO_IDENTIFIER, forIndexPath: path)
      cell.image = photos[path.item - offset].thumbnail_path
    end

    cell
  end

  def collectionView(view, didSelectItemAtIndexPath: path)
    if path.item == 0
      camera = CameraController.new
      camera.structure = parentViewController.structure
      navigationController.pushViewController(camera, animated: false)
    else
      photo_controller = PhotoController.new
      photo_controller.file_path = photos[path.item - offset].original_path
      navigationController.presentViewController(photo_controller,
                                                 animated: true,
                                                 completion: nil)
    end
  end

  private

  def offset
    can_edit_current_audit? ? 1 : 0
  end

  def structure_images
    parentViewController.structure.structure_images
  end
end
