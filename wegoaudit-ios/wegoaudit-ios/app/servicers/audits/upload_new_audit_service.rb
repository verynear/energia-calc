# Service to upload an audit created on the device
class UploadNewAuditService < BaseServicer
  include AppDelegateTools

  attr_accessor :audit, :errors

  def execute!
    client.post('audits', audit: audit.attributes) do |result|
      if result.success?
        audit.set_attributes(result.object)
      else
        NSLog("Unable to upload audit")
      end
    end
  end
end
