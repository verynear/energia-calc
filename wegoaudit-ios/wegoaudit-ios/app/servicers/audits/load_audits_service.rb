# Service to download audit objects objects
class LoadAuditsService < BaseServicer
  include AppDelegateTools

  def execute!
    client.get('audits') do |result|
      if result.success?
        result.object.each do |audit_params|
          service = AuditHandlerService.new(params: audit_params)
          service.execute!
          NSLog("Updated audit id: #{audit_params['id']} params: #{audit_params}")
        end
      else
        NSLog('Unable to download Audits')
      end
    end
  end
end
