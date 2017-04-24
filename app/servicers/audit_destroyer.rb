class AuditDestroyer < BaseServicer
  attr_accessor :audit

  def execute!
    StructureDestroyer.execute(structure: @audit.structure)
    audit.audit_measure_values.destroy_all
    audit.destroy
  end
end
