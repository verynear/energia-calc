FactoryGirl.define do
  factory :field_value do
    value 'something'
    parent { create(:structure) }
  end
end
