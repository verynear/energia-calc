namespace :schema do
  desc 'Copy schema from Wegoaudit'
  task sync: :environment do
    validator = WegoauditSchemaValidator.new
    path = validator.schema_path('audit')
    cp(path, Rails.root.join('docs', 'schemas', 'audit.json'))
  end
end
