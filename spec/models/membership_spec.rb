require 'rails_helper'

describe Membership do
  it { should validate_presence_of :organization }
  it { should validate_presence_of :user }

  it { should belong_to(:user) }
  it { should belong_to(:organization) }

  it { should allow_value(nil).for(:access) }
  it { should allow_value('edit').for(:access) }
  it { should allow_value('view').for(:access) }
  it { should_not allow_value('own').for(:access) }

  it { should allow_value('member').for(:role) }
  it { should allow_value('admin').for(:role) }
  it { should allow_value('owner').for(:role) }
  it { should_not allow_value('doh').for(:role) }
  it { should_not allow_value(nil).for(:role) }
end
