FactoryGirl.define do
  factory :user do
    sequence(:username) { |username| "name#{username}" }
    first_name { username.capitalize }
    last_name 'User'
    provider 'wegowise'
    sequence(:wegowise_id) { |id| id }
    token 'token'
    secret 'secret'
  end
end
