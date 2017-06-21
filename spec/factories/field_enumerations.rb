# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :field_enumeration do
    audit_field nil
    value "MyString"
    display_order 1
    successful_upload_on "2014-10-01 19:12:13"
    upload_attempt_on "2014-10-01 19:12:13"
  end
end
