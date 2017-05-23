class AuditStructuresController < SecuredController
  include RemoteObjectProcessing

  before_action :load_structure, except: [:create]
  def show
    render json: AuditStructure.find(params[:id])
  end

  def create
    render json: process_object(AuditStructure, audit_structure_params)
  end

  def update
    render json: process_object(AuditStructure, audit_structure_params)
  end

  def export_full
    render json: [FullStructurePresenter.new(@audit_structure)]
  end

  private

  def load_structure
    @audit_structure = AuditStructure.find(params[:id])
  end

  def audit_structure_params
    params.require(:audit_structure)
          .permit(:id,
                  :destroy_attempt_on,
                  :audit_strc_type_id,
                  :name,
                  :successful_upload_on,
                  :upload_attempt_on,
                  :parent_structure_id,
                  :sample_group_id,
                  :full_download_on,
                  :physical_structure_id,
                  :physical_structure_type,
                  :created_at,
                  :updated_at)
  end
end
