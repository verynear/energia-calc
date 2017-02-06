# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audit do
    name "MyString"
    is_archived false
    performed_on "2014-09-09 12:50:53"
    user nil

    trait :deleted do
      destroy_attempt_on { DateTime.current }
    end

    before(:create) do |audit, evaluator|
      unless audit.structure.present?
        audit.structure = create(:structure,
                                 structure_type: create(:audit_structure_type),
                                 name: audit.name)
      end
    end

    after(:create) do |audit, evaluator|
      unless audit.audit_type.present?
        audit.audit_type = create(:audit_type)
        audit.save
      end
    end
  end
end
