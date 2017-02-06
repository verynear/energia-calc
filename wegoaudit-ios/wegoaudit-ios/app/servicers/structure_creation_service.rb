class StructureCreationService < BaseServicer
  attr_accessor :params,
                :parent_structure,
                :structure,
                :structure_type

  def execute!
    create_structure
    create_physical_structure
  end

  def create_structure
    @structure = Structure.create_with_uuid(structure_params)
  end

  def create_physical_structure
    return unless structure_type.has_physical_structure?
    object_class = structure_type.physical_structure_class
    @physical_structure = object_class.create_with_uuid(params)
    @physical_structure.name = name
    @structure.physical_structure_type = structure_type.physical_structure_type
    @structure.physical_structure_id = @physical_structure.id
  end

  def name
    params[:name]
  end

  def parent_structure_id
    parent_structure.id if parent_structure
  end

  def structure_params
    params.merge(
      structure_type_id: structure_type.id,
      parent_structure_id: parent_structure_id
    )
  end
end
