class SampleGroupsController < SecuredController
  include RemoteObjectProcessing

  before_filter :load_sample_group, except: [:create]

  def show
    render json: @sample_group
  end

  def create
    render json: process_object(SampleGroup, sample_group_params)
  end

  def update
    render json: process_object(SampleGroup, sample_group_params)
  end

  private

  def load_sample_group
    @sample_group = SampleGroup.find(params[:id])
  end

  def sample_group_params
    params.require(:sample_group)
          .permit(:created_at,
                  :destroy_attempt_on,
                  :full_download_on,
                  :id,
                  :n_structures,
                  :name,
                  :parent_structure_id,
                  :structure_type_id,
                  :successful_upload_on,
                  :updated_at,
                  :upload_attempt_on)
  end
end
