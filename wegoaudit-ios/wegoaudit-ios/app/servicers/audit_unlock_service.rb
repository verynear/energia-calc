# This class is responsible for trying to unlock an audit for a user.
# This is a POST request to the server.
class AuditUnlockService < BaseServicer
  include AppDelegateTools
  include CDQ

  attr_accessor :audit,
                :user

  def execute!
    client.post("audits/#{audit_id}/unlock") do |result|
      handle_lock_result(result)
    end
  end

  private

  def audit_id
    @audit_id ||= audit.id
  end

  def handle_lock_result(result)
    if result.success?
      NSLog("Audit #{audit_id} was unlocked")
      cdq.save
    elsif result.status_code == 401
      NSLog("Failed to unlock audit #{audit_id}")
    end
  rescue NoMethodError => err
    NSLog("Failed to unlock audit #{audit_id}. Server is unreachable.")
  end
end
