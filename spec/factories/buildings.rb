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
        create(:audit_structure, physical_structure: building,
                           audit_strc_type: create(:building_audit_strc_type),
                           name: building.nickname)
      end
    end
  end
end
