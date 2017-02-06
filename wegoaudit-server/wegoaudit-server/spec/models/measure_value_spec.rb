require 'rails_helper'

describe MeasureValue do
  it { should belong_to :audit }
  it { should belong_to :measure }
  it { should validate_presence_of :audit_id }
  it { should validate_presence_of :measure_id }
end
