# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization_building do
    association :organization
    association :building
    active true
  end
end
