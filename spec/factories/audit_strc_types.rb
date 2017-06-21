# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audit_strc_type do
    parent_structure_type nil
    primary true
    sequence(:name) { |n| "structure_type#{n}" }
    active true

    factory :apartment_audit_strc_type do
      physical_structure_type 'Apartment'
      name 'Apartment'
      api_name 'apartment'
    end

    factory :audit_audit_strc_type do
      name 'Audit'
      api_name 'audit'
    end

    factory :building_audit_strc_type do
      physical_structure_type 'Building'
      name 'Building'
      api_name 'building'
    end

    factory :meter_audit_strc_type do
      physical_structure_type 'Meter'
      name 'Meter'
      api_name 'meter'
    end

    factory :common_area_audit_strc_type do
      name 'Common Area'
      api_name 'common_area'
    end
  end
end
