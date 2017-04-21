FactoryGirl.define do
  factory :structure_type do
    sequence(:name) { |num| "Structure type #{num}" }

    before(:create) do |structure_type, _evaluator|
      unless structure_type.api_name
        structure_type.api_name = structure_type.name.underscore.gsub(/\W+/, '_')
      end
      unless structure_type.genus_api_name
        structure_type.genus_api_name = structure_type.api_name
      end
    end
  end
end
