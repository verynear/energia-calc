class AuditCreator < BaseServicer
  attr_accessor :params,
                :user

  attr_reader :audit

  def execute!
    Audit.transaction do
      initialize_audit
      initialize_audit_structure
      touch_upload_timestamps
      audit.save!
    end
  end

  private

  def audit_params
    params.require(:audit)
          .permit(:audit_type_id,
                  :name,
                  :performed_on,
                  :organization_id)
  end

  def audit_strc_type
    @audit_strc_type ||= AuditStrcType.find_by(name: 'Audit')
  end

  def initialize_audit
    @audit = user.audits.new(audit_params)
  end

  def initialize_audit_structure
    audit.audit_structure = AuditStructure.new(
      name: audit.name,
      audit_strc_type: audit_strc_type
    )
  end

  def touch_upload_timestamps
    audit.upload_attempt_on = audit.successful_upload_on = DateTime.current
  end
end
