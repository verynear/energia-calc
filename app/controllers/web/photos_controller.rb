module Web
  class PhotosController < BaseController
    skip_before_action :authenticate_user!, only: [:download]

    def create
      audit_structure = AuditStructure.find(photo_params[:audit_structure_id])
      image = audit_structure.structure_images.new(photo_params)
      if image.save
        flash[:notice] = 'New image uploaded!'
      else
        flash[:alert] = 'Unable to save image.'
      end
      redirect_to audit_structure.audit || [current_audit, audit_structure]
    end

    def destroy
      image = StructureImage.find(params[:id])
      image.destroy
      redirect_to_parent image
    end

    def download
      @image = StructureImage.find(params[:id])
      redirect_to @image.image_url(params[:size].to_sym)
    end

    private

    def file_name_param
      params.require(:structure_image)
            .fetch(:image)
            .original_filename
    end

    def photo_params
      params.require(:structure_image)
            .permit(:image, :audit_structure_id, :image_remote_url)
            .merge(file_name: file_name_param)
            .merge(timestamp_params)
    end

    def timestamp_params
      current_timestamp = DateTime.current
      {
        upload_attempt_on: current_timestamp,
        successful_upload_on: current_timestamp
      }
    end
  end
end
