class StructureCreator < BaseServicer
  attr_accessor :params,
                :parent_structure,
                :structure_type

  attr_reader :structure

  def execute!
    Structure.transaction do
      create_structure
      create_physical_structure
    end
  end

  private

  def create_structure
    @structure = Structure.create(structure_params)
  end

  def create_physical_structure
    return unless structure_type.has_physical_structure?

    object_class = structure_type.physical_structure_class
    physical_structure = object_class.new
    physical_structure.name = structure.name
    physical_structure.successful_upload_on = current_timestamp
    physical_structure.upload_attempt_on = current_timestamp
    physical_structure.save

    structure.update(
      physical_structure_type: structure_type.physical_structure_type,
      physical_structure_id: physical_structure.id,
    )
  end

  def current_timestamp
    @current_timestamp || DateTime.current
  end

  def structure_params
    params.merge(
      parent_structure_id: parent_structure.id,
      structure_type_id: structure_type.id,
      successful_upload_on: current_timestamp,
      upload_attempt_on: current_timestamp
    )
  end
end
