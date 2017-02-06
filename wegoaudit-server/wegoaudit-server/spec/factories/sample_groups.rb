FactoryGirl.define do
  factory :sample_group do
    structure_type nil
    n_structures 42
    name "My Sample Group"
    successful_upload_on "2014-10-10 15:36:02"
    upload_attempt_on "2014-10-10 15:36:02"

    before(:create) do |sample_group, evaluator|
      unless sample_group.structure_type.present?
        sample_group.structure_type = create(:structure_type)
      end
    end
  end
end
