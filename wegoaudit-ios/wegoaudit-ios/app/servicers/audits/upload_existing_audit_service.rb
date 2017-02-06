# Service to update Audits
class UploadExistingAuditService < BaseServicer
  include AppDelegateTools

  attr_accessor :audit

  def execute!
    audit.upload_attempt_on = Time.now
    client.put("audits/#{audit.id}", audit: audit.attributes) do |result|
      if result.success?
        audit.set_attribute(:successful_upload_on, result.object['successful_upload_on'])
        NSLog("Succesfully uploaded audit id: #{audit.id} at #{audit.successful_upload_on}")
      else
        NSLog("Unable to upload existing audit id: #{audit.id} at #{audit.upload_attempt_on}")
      end
    end
  end
end
