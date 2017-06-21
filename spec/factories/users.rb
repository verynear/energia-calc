FactoryGirl.define do
  factory :user do
    sequence(:username) { |username| "name#{username}" }
    first_name { username.capitalize }
    last_name 'User'
    provider 'wegowise'
    sequence(:wegowise_id) { |id| id }
    sequence(:email) { |n| "email#{n}@factory.com" }
    organization_id '29efb419-f657-69e2-a543-f5af358a4e5d'
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end
end
