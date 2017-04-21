require 'rails_helper'

describe AuditType do
  it { should have_many :audits }
  it { should validate_presence_of :name }
end
