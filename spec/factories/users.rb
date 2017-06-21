FactoryGirl.define do
  factory :user do
    sequence(:username) { |username| "name#{username}" }
    first_name { username.capitalize }
    last_name 'User'
    provider 'wegowise'
    sequence(:wegowise_id) { |id| id }
    sequence(:email) { |n| "email#{n}@factory.com" }
    token 'token'
    secret 'secret'
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
  end
end
