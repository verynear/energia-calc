module Retrocalc
  class StructureTypesController < Retrocalc::ApiController
    before_filter :load_user

    def index
      structure_types_json = StructureType.uniq(:api_name).order(:id)
        .map do |structure_type|
        next if structure_type.api_name == 'audit'
        StructureTypeJsonPresenter.new(structure_type).as_json
      end.compact

      render json: { structure_types: structure_types_json }
    end
  end
end
