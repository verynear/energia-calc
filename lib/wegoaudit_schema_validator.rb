class WegoauditSchemaValidator
  attr_reader :base_schemas_path

  def initialize(base_schemas_path: ENV['BASE_JSON_SCHEMAS_PATH'])
    base_schemas_path ||= Rails.root.join('docs', 'schemas')
    @base_schemas_path = base_schemas_path
  end

  def schema_path(schema)
    "#{base_schemas_path}/#{schema}.json"
  end

  def validate!(schema, data)
    JSON::Validator.validate!(schema_path(schema), data)
  end
end
