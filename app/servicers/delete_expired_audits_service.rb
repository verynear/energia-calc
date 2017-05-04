class DeleteExpiredAuditsService < BaseServicer
  def execute!
    Audit.includes(:audit_structure).to_destroy.each do |audit|
      AuditDestroyer.execute!(audit: audit)
    end
  end
end
