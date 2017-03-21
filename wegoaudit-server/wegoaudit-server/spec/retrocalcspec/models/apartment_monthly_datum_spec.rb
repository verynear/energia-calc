require 'rails_helper'

describe ApartmentMonthlyDatum do
  it { should validate_presence_of(:wegowise_id) }
  it { should validate_presence_of(:data_type) }

  it { is_expected.to belong_to(:audit_report) }
end
