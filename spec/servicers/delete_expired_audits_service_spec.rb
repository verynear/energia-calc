require 'rails_helper'

describe DeleteExpiredAuditsService do
  let!(:unexpired_date) { Date.current - 20.days }
  let!(:expired_date) { Date.current - 40.days }
  let!(:expired_audit) { create(:audit, destroy_attempt_on: expired_date) }
  let(:not_destroyed_audit) { create(:audit) }
  let(:destroyed_audit) { create(:audit, destroy_attempt_on: unexpired_date) }

  describe 'execute' do
    it 'destroys expired audits' do
      expect(AuditDestroyer).to receive(:execute!)
        .with(audit: expired_audit)
        .and_return(true)
      expect(AuditDestroyer).to_not receive(:execute!)
        .with(audit: not_destroyed_audit)
      expect(AuditDestroyer).to_not receive(:execute!)
        .with(audit: destroyed_audit)

      DeleteExpiredAuditsService.execute!
    end
  end
end
