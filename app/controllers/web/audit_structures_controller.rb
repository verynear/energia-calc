module Web
  class AuditStructuresController < BaseController
    def clone
      source_structure = AuditStructure.find(params[:source_structure_id])
      StructureMulticloneService.execute!(n_copies: params.fetch(:n_copies, 1).to_i,
                                          audit_structure: source_structure,
                                          pattern: params.fetch(:pattern))

      redirect_to_parent source_structure
    end

    def create
      # TODO: cleanup
      audit_strc_type = AuditStrcType.find(
        params[:structure_subtype] || params[:audit_strc_type]
      )
      if params[:audit_structure][:parent_structure_id].present?
        parent_structure = AuditStructure.find(params[:audit_structure][:parent_structure_id])
        creator = AuditStructureCreator.new(
          params:  params.require(:audit_structure).permit(:name),
          parent_structure: parent_structure,
          audit_strc_type: audit_strc_type
        )
        creator.execute!
        audit_structure = creator.audit_structure
        redirect_to_parent audit_structure
      elsif params[:audit_structure][:sample_group_id].present?
        sample_group = SampleGroup.find(params[:audit_structure][:sample_group_id])
        
        if audit_strc_type.name == 'Apartment'
          parent_structure = AuditStructure.find(sample_group.parent_structure_id)
          creator = AuditStructureCreator.new(
            params:  params.require(:audit_structure).permit(:name),
            parent_structure: parent_structure,
            audit_strc_type: audit_strc_type
          )
          creator.execute!
          audit_structure = creator.audit_structure
          audit_structure.update(sample_group_id: sample_group.id)
        else
          audit_structure = AuditStructure.create(
            name: audit_structure_params[:name],
            sample_group_id: sample_group.id,
            audit_strc_type_id: audit_strc_type.id,
            parent_structure_id: sample_group.parent_structure_id
          )
        end

        redirect_to [current_audit, audit_structure.sample_group]
      end
    end

    def destroy
      audit_structure = AuditStructure.find(params[:id])
      StructureDestroyer.execute(audit_structure: audit_structure)
      redirect_to_parent audit_structure, notice: "'#{audit_structure.name}' has been deleted."
    end

    def link
      audit_structure = AuditStructure.find(params[:id])
      building = Building.find(params[:building_id])
      StructureLinkService.execute!(audit_structure: audit_structure,
                                    physical_structure: building)
      redirect_to_parent audit_structure
    end

    def show
      @tab = params[:tab]
      @audit_structure = AuditStructure.find(params[:id])
      @substructure = AuditStructure.new(parent_structure: @audit_structure)
      @sample_group = SampleGroup.new(parent_structure: @audit_structure)
    end

    def update
      audit_structure = AuditStructure.find(params[:id])
      audit_structure_params = params.require(:audit_structure).permit(:name)
      AuditStructure.transaction do
        audit_structure.update!(audit_structure_params)
        audit_structure.audit.update!(name: audit_structure.name) if audit_structure.audit
      end
      head 204
    rescue ActiveRecord::RecordInvalid
      head 422
    end

    private

    def audit_structure_params
      params.require(:audit_structure)
            .permit(:name,
                    :parent_structure_id,
                    :sample_group_id,
                    :audit_strc_type_id)
    end
  end
end
