FactoryGirl.define do
  factory :apartment do
    wegowise_id 1
    sqft 1000
    unit_number '101a'
    n_bedrooms 2
    association :building

    after(:create) do |apartment, evaluator|
      create(:structure, physical_structure: apartment,
                         structure_type: create(:apartment_structure_type),
                         name: apartment.unit_number)
    end
  end

end
