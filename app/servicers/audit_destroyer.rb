class AuditDestroyer < BaseServicer
  attr_accessor :audit

  def execute!
    StructureDestroyer.execute(audit_structure: @audit.audit_structure)
    audit.audit_measure_values.destroy_all
    audit.destroy
  end
end
