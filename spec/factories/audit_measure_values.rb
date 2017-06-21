FactoryGirl.define do
  factory :audit_measure_value do
    audit_measure_id ""
    audit_id ""
    value false
    destroy_attempt_on nil
    upload_attempt_on nil
    notes "MyString"
  end
end
