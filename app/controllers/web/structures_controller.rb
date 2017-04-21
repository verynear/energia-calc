module Web
  class StructuresController < BaseController
    def clone
      source_structure = Structure.find(params[:source_structure_id])
      StructureMulticloneService.execute!(n_copies: params.fetch(:n_copies, 1).to_i,
                                          structure: source_structure,
                                          pattern: params.fetch(:pattern))

      redirect_to_parent source_structure
    end

    def create
      # TODO: cleanup
      structure_type = StructureType.find(
        params[:structure_subtype] || params[:structure_type]
      )
      if params[:structure][:parent_structure_id].present?
        parent_structure = Structure.find(params[:structure][:parent_structure_id])
        creator = StructureCreator.new(
          params: params.require(:structure).permit(:name),
          parent_structure: parent_structure,
          structure_type: structure_type
        )
        creator.execute!
        structure = creator.structure
        redirect_to_parent structure
      elsif params[:structure][:sample_group_id].present?
        sample_group = SampleGroup.find(params[:structure][:sample_group_id])
        structure = Structure.create(
          name: structure_params[:name],
          sample_group_id: sample_group.id,
          structure_type_id: structure_type.id
        )
        redirect_to [current_audit, structure.sample_group]
      end
    end

    def destroy
      structure = Structure.find(params[:id])
      StructureDestroyer.execute(structure: structure)
      redirect_to_parent structure, notice: "'#{structure.name}' has been deleted."
    end

    def link
      structure = Structure.find(params[:id])
      building = current_user.buildings.find(params[:building_id])
      StructureLinkService.execute!(structure: structure,
                                    physical_structure: building)
      redirect_to_parent structure
    end

    def show
      @structure = Structure.find(params[:id])
      @substructure = Structure.new(parent_structure: @structure)
      @sample_group = SampleGroup.new(parent_structure: @structure)
    end

    def update
      structure = Structure.find(params[:id])
      structure_params = params.require(:structure).permit(:name)
      Structure.transaction do
        structure.update!(structure_params)
        structure.audit.update!(name: structure.name) if structure.audit
      end
      head 204
    rescue ActiveRecord::RecordInvalid
      head 422
    end

    private

    def structure_params
      params.require(:structure)
            .permit(:name,
                    :parent_structure_id,
                    :sample_group_id,
                    :structure_type_id)
    end
  end
end
