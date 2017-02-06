class AuditDestroyer < BaseServicer
  attr_accessor :audit

  def execute!
    StructureDestroyer.execute!(structure: audit.structure,
                                local: true)
    audit.destroy(true)
  end

  def destroy_measure_values
    audit.measure_values.each do |measure_value|
      measure_value.destroy(true)
    end
  end
end
