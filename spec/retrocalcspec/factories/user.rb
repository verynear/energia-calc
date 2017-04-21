FactoryGirl.define do
  factory :user do
    sequence(:username) { |username| "name#{username}" }
    provider 'wegowise'
    sequence(:wegowise_id) { |id| id }
    token 'token'
    secret 'secret'
  end
end
