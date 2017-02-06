class DeleteExpiredAuditsService < BaseServicer
  def execute!
    Audit.includes(:structure).to_destroy.each do |audit|
      AuditDestroyer.execute!(audit: audit)
    end
  end
end
