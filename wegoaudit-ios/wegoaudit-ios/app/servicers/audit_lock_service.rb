# This class is responsible for trying to obtain a lock an an audit for a user.
# This is a POST request to the server.
class AuditLockService < BaseServicer
  include AppDelegateTools
  include CDQ

  attr_accessor :audit,
                :user

  def execute!
    return unless audit_has_been_uploaded?
    return if audit.is_locked?

    client.post("audits/#{audit.id}/lock") do |result|
      handle_lock_result(result)
    end
  end

  private

  def audit_has_been_uploaded?
    !audit.successful_upload_on.nil?
  end

  def handle_lock_result(result)
    if result.success?
      NSLog("Lock obtained on audit #{audit.id}")
      audit.locked_by = current_user.id
      FullStructureDownloadService.execute!(structure_id: audit.structure_id)
      cdq.save
    elsif result.status_code == 401
      NSLog("Failed to obtain a lock on audit #{audit.id}")
    elsif result.status_code == 404
      NSLog("Audit #{audit.id} has not been uploaded")
    end
  rescue NoMethodError => err
    NSLog("Failed to obtain a lock. Server is unreachable.")
  end
end
