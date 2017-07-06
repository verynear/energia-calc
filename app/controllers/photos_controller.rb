class PhotosController < ApplicationController
  before_filter :authenticate_user!,
                :load_structure

  def index
    @images = @audit_structure.structure_images
  end

  def create
    @image = @audit_structure.structure_images.find_or_create_by(id: params[:id])
    if @image.update_attributes(image_params)
      @image.update(successful_upload_on: @image.upload_attempt_on)
      render json: @image, status: :ok
    else
      render json: @image, status: :forbidden
    end
  end

  private

  def load_structure
    @audit_structure = AuditStructure.find(params[:audit_structure_id])
  end

  def image_params
    params.permit(:image,
                  :file_name,
                  :upload_attempt_on)
  end
end
