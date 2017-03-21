FactoryGirl.define do
  factory :field do
    sequence(:name) { |num| "Structure type #{num}" }
    value_type 'string'
    before(:create) do |field, _evaluator|
      next if field.api_name
      field.api_name = field.name.underscore.gsub(/\W+/, '_')
    end
  end
end
