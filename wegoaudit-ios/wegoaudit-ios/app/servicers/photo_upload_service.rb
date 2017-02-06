class PhotoUploadService < BaseServicer
  include AppDelegateTools

  attr_accessor :image

  def initialize(*args)
    @start_time = Time.now
    @semaphore = Dispatch::Semaphore.new(0)
    @changed = false
    super(*args)
  end

  def execute!
    return unless upload_required?

    attempt_image_upload do |result|
      if result.success?
        image.set_attribute(:upload_attempt_on, result.object['upload_attempt_on'])
        image.set_attribute(:successful_upload_on, result.object['successful_upload_on'])
      else
        image.upload_attempt_on = @start_time
      end
      @changed = true
      @semaphore.signal
    end

    @semaphore.wait
  end

  def changed?
    @changed
  end

  private

  def attempt_image_upload(&block)
    client.multipart_post(post_url, post_data) do |result, form_data|
      if form_data
        form_data.appendPartWithFileURL(image_path, name: 'asset', error: nil)
      else
        block.call(result)
      end
    end
  end

  def image_path
    NSURL.fileURLWithPath(image.original_path)
  end

  def post_data
    {
      id: image.id,
      file_name: file_name,
      upload_attempt_on: @start_time
    }
  end

  def post_url
    "structures/#{structure_id}/photos"
  end

  def file_name
    @file_name ||= File.basename(image.original_path)
  end

  def structure_id
    image.structure.id
  end

  def upload_required?
    image.successful_upload_on.nil? || # never uploaded
      image.upload_attempt_on != image.successful_upload_on # failed
  end
end
