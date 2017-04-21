RSpec::Matchers.define :match_response_schema do |schema|
  match do |data|
    schema_directory = File.join(Rails.root, 'docs', 'schemas')
    schema_path = "#{schema_directory}/#{schema}.json"
    JSON::Validator.validate!(schema_path, data)
  end
end
