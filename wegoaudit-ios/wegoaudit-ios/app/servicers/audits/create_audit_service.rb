# Service to create a new audit from a hash of attributes.
class CreateAuditService < BaseServicer
  attr_accessor :audit, :user

  def execute!
    Audit.create_with_uuid(
      name: audit_name,
      performed_on: audit_performed_on_date,
      user_id: user.id,
      locked_by: user.id,
      structure_id: structure.id,
      audit_type_id: audit_type.id)
  end


  private

  def audit_name
    audit[:name]
  end

  def audit_structure_type
    @audit_structure_type ||= StructureType.where(name: 'Audit').first
  end

  def audit_type
    @audit_type ||= AuditType.active
      .where(name: audit[:audit_type])
      .first
  end

  def audit_performed_on_date
    Time.at(audit[:performed_on])
  end

  def structure
    @structure ||= Structure.create_with_uuid(
      name: audit_name,
      structure_type_id: audit_structure_type.id)
  end
end
