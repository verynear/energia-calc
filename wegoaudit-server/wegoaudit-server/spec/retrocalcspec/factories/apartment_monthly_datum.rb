FactoryGirl.define do
  factory :apartment_monthly_datum do
    sequence(:wegowise_id) { |id| id }
    data_type 'electric'
    data [{ 'date' => 'date', 'value' => 1.0 }]
    audit_report
  end
end
