class WegoauditDataImporter
  def import!(&block)
    import_entities(:structure_types, &block)
  end

  def import_entities(type)
    begin
      client = AuditDigest.new(organization_id: nil)
      entities = client.public_send("#{type}_list")
    rescue Errno::ECONNREFUSED
      puts 'You need to run a corresponding Wegoaudit instance' # rubocop:disable Rails/Output
      exit
    end

    entities.each do |api_entity|
      klass = type.to_s.singularize.camelize.constantize

      next unless yield api_entity, type

      entity = klass.find_or_initialize_by(api_name: api_entity['api_name'])
      entity.attributes = api_entity
      entity.save!
    end
  end
end
