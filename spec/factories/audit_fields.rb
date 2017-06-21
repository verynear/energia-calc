# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audit_field do
    name "MyString"
    api_name 'my_string'
    placeholder "MyString"
    value_type "string"
    sequence(:display_order)
    successful_upload_on "2014-10-01 18:43:10"
    upload_attempt_on "2014-10-01 18:43:10"
    grouping nil

    trait :date do
      value_type 'date'
    end

    trait :currency do
      value_type 'currency'
    end

    trait :decimal do
      value_type 'decimal'
    end

    trait :email do
      value_type 'email'
    end

    trait :float do
      value_type 'float'
    end

    trait :integer do
      value_type 'integer'
    end

    trait :phone do
      value_type 'phone'
    end

    trait :state do
      value_type 'state'
    end

    trait :string do
      value_type 'string'
    end

    trait :text do
      value_type 'text'
    end

    trait :switch do
      value_type 'switch'
    end
  end
end
