RSpec::Matchers.define :match_response_schema do |data|
  match do |schema|
    WegoauditSchemaValidator.new.validate!(data, schema)
  end
end
