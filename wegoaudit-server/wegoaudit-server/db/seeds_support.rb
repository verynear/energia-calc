def load_fields_from_yaml(type, level)
  fields = YAML.load_file(Rails.root.join('db', 'fixtures', "#{type}_fields.yml"))

  fields.map do |api_name, options|
    # This will blow up if an existing field tries to change value_type, due to
    # the duplicate api_name. This is on purpose to avoid a namespace collision
    # with Wegoaudit.
    #
    field = Field.find_or_initialize_by(
      api_name: api_name,
      value_type: options['value_type'])
    field.attributes = options.merge(level: level)
    begin
      field.save!
    rescue ActiveRecord::RecordInvalid => e
      raise "Problem with #{field.api_name}: #{e}"
    end
    field
  end
end
