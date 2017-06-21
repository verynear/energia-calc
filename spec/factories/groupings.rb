# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grouping do
    audit_strc_type { create(:audit_strc_type) }
    name "MyString"
    display_order 1
    successful_upload_on "2014-10-01 17:55:27"
    upload_attempt_on "2014-10-01 17:55:27"
  end
end
