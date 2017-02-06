# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :structure_type do
    parent_structure_type nil
    primary true
    sequence(:name) { |n| "structure_type#{n}" }
    active true

    factory :apartment_structure_type do
      physical_structure_type 'Apartment'
      name 'Apartment'
      api_name 'apartment'
    end

    factory :audit_structure_type do
      name 'Audit'
      api_name 'audit'
    end

    factory :building_structure_type do
      physical_structure_type 'Building'
      name 'Building'
      api_name 'building'
    end

    factory :meter_structure_type do
      physical_structure_type 'Meter'
      name 'Meter'
      api_name 'meter'
    end

    factory :common_area_structure_type do
      name 'Common Area'
      api_name 'common_area'
    end
  end
end
