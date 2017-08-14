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
      redirect_to @image.image_url(params[:size])
    end

    def google_photo_download
      @image = StructureImage.find(params[:id])
      redirect_to @image.photo_path
    end

    private

    def photo_params
      params.require(:structure_image)
            .permit(:image, :audit_structure_id, :image_remote_url)
            .merge(file_name: image_filename)
            .merge(photo_path: photo_path_url)
            .merge(timestamp_params)
    end

    def photo_path_url
      params[:structure_image]['image_remote_url']
    end

    def filename_param
      params.require(:structure_image)
            .permit(:remote_name)
    end

    def photo_path_param
      params.require(:structure_image)
            .permit(:photo_path)
    end


    def image_filename
      if params[:structure_image]['image'].try(:original_filename) != nil
        params[:structure_image]['image'].try(:original_filename)
      else 
        params[:structure_image]['remote_name']
      end
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
