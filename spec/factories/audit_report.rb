FactoryGirl.define do
  factory :audit_report do
    data do
      {
        'name' => name,
        'date' => Date.today,
        'audit_structures' => []
      }
    end
    sequence(:name) { |num| "report#{num}" }
    user

    initialize_with do
      AuditReportCreator.new(
        data: data,
        user: user,
        wegoaudit_id: SecureRandom.uuid
      ).create
    end
  end
end
