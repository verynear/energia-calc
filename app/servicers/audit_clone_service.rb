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
    audit.structure = Structure.create(
      name: audit.name,
      structure_type_id: audit_structure_type_id
    )
    audit.save!
  end

  private

  def audit_structure_type_id
    source_audit.structure.structure_type_id
  end
end
