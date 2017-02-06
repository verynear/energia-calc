module ApiNameGeneration
  def generate_api_name
    self.api_name = name
      .gsub(/\W+/, '_')
      .underscore
      .gsub(/\A_+|_+\Z/, '')
  end

  def generate_api_name!
    generate_api_name
    save!
  end

  private

  def validate_unchanged_api_name
    return if api_name_was.nil?
    return unless persisted?
    return unless api_name_changed?
    errors.add(:api_name, "Can't change api_name")
  end
end
