FactoryGirl.define do
  factory :measure_value do
    measure_id ""
    audit_id ""
    value false
    destroy_attempt_on nil
    upload_attempt_on nil
    notes "MyString"
  end
end
