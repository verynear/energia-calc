FactoryGirl.define do
  factory :organization do
    name 'pandas'
    sequence(:wegowise_id) { |id| id }
  end
end
