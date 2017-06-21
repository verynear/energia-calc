module AuditDigest
 def audit_payload(data)
    payload = { 'audit' => data }
    expect(payload).to match_response_schema('retrocalc/audit')
    payload
  end
end