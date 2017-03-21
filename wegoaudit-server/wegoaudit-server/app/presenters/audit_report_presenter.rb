class AuditReportPresenter < DelegateClass(AuditReport)
  def initialize(*)
    super
  end

  def annual_gas_usage_reduction_percentage
    'UNIMPLEMENTED'
  end

  def cover_image
    audit.photos.find do |photo|
      photo['id'] == wegoaudit_photo_id
    end
  end

  def cover_image_url
    return unless cover_image

    response = Net::HTTP.get_response(URI(cover_image['medium_url']))
    image = Net::HTTP.get(URI(response['location']))
    @tempfile = Tempfile.new(['image', '.jpg'])
    @tempfile.binmode
    @tempfile.write(image)
    @tempfile.rewind
    @tempfile.path
  end

  def demo_cover_image_url
    Rails.root.join('public', 'images', "#{layout}/cover-image-demo.jpg")
  end

  def layout
    report_template.layout
  end

  def method_missing(mthd, *args)
    return super unless field_values.map(&:field_api_name).include?(mthd.to_s)

    self.class.send(:define_method, mthd) do
      field_values.find_by(field_api_name: mthd).try!(:value)
    end
    public_send(mthd)
  end
end
