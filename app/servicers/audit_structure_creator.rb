class AuditStructureCreator < BaseServicer
  attr_accessor :params,
                :parent_structure,
                :audit_strc_type

  attr_reader :structure

  def execute!
    AuditStructure.transaction do
      create_structure
      create_physical_structure
    end
  end

  private

  def create_structure
    @audit_structure = AuditStructure.create(audit_structure_params)
  end

  def create_physical_structure
    return unless audit_strc_type.has_physical_structure?

    object_class = audit_strc_type.physical_structure_class
    physical_structure = object_class.new
    physical_structure.name = audit_structure.name
    physical_structure.successful_upload_on = current_timestamp
    physical_structure.upload_attempt_on = current_timestamp
    physical_structure.save

    audit_structure.update(
      physical_structure_type: audit_strc_type.physical_structure_type,
      physical_structure_id: physical_structure.id,
    )
  end

  def current_timestamp
    @current_timestamp || DateTime.current
  end

  def audit_structure_params
    params.merge(
      parent_structure_id: parent_structure.id,
      audit_strc_type_id: audit_strc_type.id,
      successful_upload_on: current_timestamp,
      upload_attempt_on: current_timestamp
    )
  end
end
