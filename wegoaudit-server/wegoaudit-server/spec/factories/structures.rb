# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :structure do
    structure_type nil
    name "MyString"
    successful_upload_on "2014-10-10 15:36:02"
    upload_attempt_on "2014-10-10 15:36:02"

    before(:create) do |structure, evaluator|
      next if structure.structure_type
      structure.structure_type = create(:structure_type)
    end
  end
end
