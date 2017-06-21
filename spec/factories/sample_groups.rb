FactoryGirl.define do
  factory :sample_group do
    audit_strc_type nil
    n_structures 42
    name "My Sample Group"
    successful_upload_on "2014-10-10 15:36:02"
    upload_attempt_on "2014-10-10 15:36:02"

    before(:create) do |sample_group, evaluator|
      unless sample_group.audit_strc_type.present?
        sample_group.audit_strc_type = create(:audit_strc_type)
      end
    end
  end
end
