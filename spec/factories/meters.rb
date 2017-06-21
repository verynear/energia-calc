FactoryGirl.define do
  factory :meter do
    wegowise_id 1
    scope 'BuildingMeter'
    account_number 'a1234'

    factory :water_meter do
      data_type 'Water'
    end

    factory :electric_meter do
      data_type 'Electric'
    end

    factory :gas_meter do
      data_type 'Gas'
    end

    after(:create) do |meter, evaluator|
      create(:audit_structure, physical_structure: meter,
                         audit_strc_type: create(:meter_audit_strc_type),
                         name: meter.account_number)
    end

  end
end
