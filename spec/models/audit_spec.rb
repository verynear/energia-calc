require 'rails_helper'

describe Audit do
  it { should belong_to :locked_by_user }
  it { should belong_to :audit_structure }
  it { should belong_to :user }
  it { should have_many :audit_field_values }

  it 'creates a new structure with the same name' do
    audit = create(:audit)
    expect(audit.name).to eq audit.audit_structure.name
  end

  describe 'soft destruction' do
    it '.active returns audits that have not been destroyed' do
      active_audit = create(:audit, destroy_attempt_on: nil)
      destroyed_audit = create(:audit, destroy_attempt_on: DateTime.current)
      expect(described_class.active).to eq [active_audit]
    end

    it '.destroyed returns audits that have been destroyed' do
      active_audit = create(:audit, destroy_attempt_on: nil)
      destroyed_audit = create(:audit, destroy_attempt_on: DateTime.current)
      expect(described_class.destroyed).to eq [destroyed_audit]
    end

    it '#soft_destroy sets the destroy_attempt_on timestamp' do
      audit = create(:audit)
      expect(audit.destroy_attempt_on).to be_nil
      audit.soft_destroy
      expect(audit.destroy_attempt_on).to be_an(ActiveSupport::TimeWithZone)
    end
  end

  it 'delegates #audit_type_name to #audit_type' do
    audit_type = AuditType.new(name: 'Foo Type')
    audit = Audit.new
    audit.audit_type = audit_type
    expect(audit.audit_type_name).to eq 'Foo Type'
  end

  describe '#is_locked?' do
    let(:audit) { Audit.new }

    it 'is locked if it has been locked by a user' do
      user = mock_model(User, id: SecureRandom.uuid)
      audit.locked_by_user = user
      expect(audit.is_locked?).to eq true
    end

    it 'is not locked if locked_by_user is nil' do
      expect(audit.is_locked?).to eq false
    end
  end

  describe '#destroy_on_date' do
    it 'returns nil if destroy_attempt_on is not set' do
      expect(Audit.new.destroy_on_date).to eq nil
    end

    it 'returns destroy_attempt_on + 30 days' do
      now = Time.current
      destroy_date = now.to_date + 30
      expect(Audit.new(destroy_attempt_on: now).destroy_on_date)
        .to eq destroy_date
    end
  end

  describe '#parent_object' do
    it { expect(described_class.new.parent_object).to eq nil }
  end

  describe '#should_be_destroyed?' do
    it 'returns false if destroy_attempt_on is not set' do
      expect(Audit.new.should_be_destroyed?).to eq false
    end

    it 'returns true if it is more than 30 days past destroy_attempt_on' do
      now = Time.current
      destroy_date = now.to_date - 31
      expect(Audit.new(destroy_attempt_on: destroy_date).should_be_destroyed?)
        .to eq true
    end

    it 'returns false if it is less than 30 days past destroy_attempt_on' do
      now = Time.current
      destroy_date = now.to_date - 29
      expect(Audit.new(destroy_attempt_on: destroy_date).should_be_destroyed?)
        .to eq false
    end
  end
end
