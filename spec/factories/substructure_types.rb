# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :substructure_type do
    parent_structure_type_id ""
    audit_strc_type_id ""
    display_order 1
  end
end
