# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
    association :owner, factory: :user
    wegowise_id 1

    after(:create) do |organization, evaluator|
      unless organization.users.include?(organization.owner)
        organization.memberships.create!(
          access: 'edit',
          role: 'owner',
          user: organization.owner)
      end
    end
  end
end
