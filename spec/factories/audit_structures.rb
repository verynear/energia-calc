# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audit_structure do
    audit_strc_type nil
    name "MyString"
    successful_upload_on "2014-10-10 15:36:02"
    upload_attempt_on "2014-10-10 15:36:02"

    before(:create) do |audit_structure, evaluator|
      next if audit_structure.audit_strc_type
      audit_structure.audit_strc_type = create(:audit_strc_type)
    end
  end
end
