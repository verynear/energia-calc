require 'rails_helper'

describe MeasureSelection do
  it { is_expected.to validate_presence_of(:measure_id) }
  it { is_expected.to validate_presence_of(:audit_report_id) }

  it { is_expected.to belong_to(:measure) }
  it { is_expected.to belong_to(:audit_report) }
  it { is_expected.to have_many(:field_values) }

  it { is_expected.to have_many(:structure_changes) }
end
