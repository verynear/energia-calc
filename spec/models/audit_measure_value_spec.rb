require 'rails_helper'

describe AuditMeasureValue do
  it { should belong_to :audit }
  it { should belong_to :audit_measure }
  it { should validate_presence_of :audit_id }
  it { should validate_presence_of :audit_measure_id }
end
