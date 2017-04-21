module Retrocalc
  class StructureTypeJsonPresenter
    attr_reader :structure_type

    def initialize(structure_type)
      @structure_type = structure_type
    end

    def as_json
      {
        name: structure_type.name,
        api_name: structure_type.api_name,
        genus_api_name: structure_type.genus_structure_type.api_name,
        parent_api_name: structure_type.parent_structure_type.api_name
      }
    end
  end
end
