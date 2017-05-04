module Web
  class SampleGroupsController < BaseController
    def create
      # TODO: cleanup
      parent_structure = AuditStructure.find(params[:sample_group][:parent_structure_id])
      audit_strc_type = AuditStrcType.find(
        params[:structure_subtype] || params[:audit_strc_type]
      )
      creator = SampleGroupCreator.new(
        params: sample_group_params,
        parent_structure: parent_structure,
        audit_strc_type: audit_strc_type
      )
      creator.execute!
      redirect_to_parent creator.sample_group
    end

    def destroy
      sample_group = SampleGroup.find(params[:id])
      SampleGroupDestroyer.execute!(sample_group: sample_group)
      redirect_to_parent sample_group,
        notice: "'#{sample_group.name}' has been deleted."
    end

    def show
      @sample_group = SampleGroup.find(params[:id])
      @substructure = AuditStructure.new(sample_group: @sample_group)
    end

    def update
      sample_group = SampleGroup.find(params[:id])
      if sample_group.update(sample_group_params)
        head 204
      else
        head 422
      end
    end

    private

    def sample_group_params
      params.require(:sample_group)
            .permit(:n_structures,
                    :name)
    end
  end
end
