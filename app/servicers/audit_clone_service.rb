class AuditCloneService < BaseServicer
  attr_accessor :audit,
                :params,
                :source_audit

  def execute!
    new_audit_params = params.merge(
      audit_type_id: source_audit.audit_type_id,
      user_id: source_audit.user_id,
      organization_id: source_audit.organization_id
    )

    self.audit = Audit.new(new_audit_params)
    audit.audit_structure = AuditStructure.create(
      name: audit.name,
      audit_strc_type_id: audit_strc_type_id
    )
    audit.save!
  end

  private

  def audit_strc_type_id
    source_audit.audit_structure.audit_strc_type_id
  end
end
