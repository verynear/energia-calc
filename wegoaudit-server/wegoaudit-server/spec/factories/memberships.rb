FactoryGirl.define do
  factory :membership do
    organization_id ''
    user_id ''
    role 'admin'
    access 'edit'
    wegowise_id 1
  end
end
