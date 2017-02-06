# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :building, :class => 'Building' do
    nickname '141 Main St'
    street_address '141 Main St'
    city 'Boston'
    state_code 'MA'
    zip_code '02111'
    draft false
    object_type 'multifamily'
    wegowise_id 123

    factory :building_with_structure do
      after(:create) do |building, evaluator|
        create(:structure, physical_structure: building,
                           structure_type: create(:building_structure_type),
                           name: building.nickname)
      end
    end
  end
end
