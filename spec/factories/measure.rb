FactoryGirl.define do
  factory :measure do
    sequence(:name) { |num| "Measure #{num}" }

    before(:create) do |measure, _evaluator|
      next if measure.api_name
      measure.api_name = measure.name.underscore.gsub(/\W+/, '_')
    end
  end
end
