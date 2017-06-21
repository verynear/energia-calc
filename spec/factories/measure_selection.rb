FactoryGirl.define do
  factory :measure_selection do
    measure { create(:measure) }
    audit_report { create(:audit_report) }
  end
end
