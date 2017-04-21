module Web
  class PhotosController < BaseController
    skip_before_action :authenticate_user!, only: [:download]

    def create
      structure = Structure.find(photo_params[:structure_id])
      image = structure.structure_images.new(photo_params)
      if image.save
        flash[:notice] = 'New image uploaded!'
      else
        flash[:alert] = 'Unable to save image.'
      end
      redirect_to structure.audit || [current_audit, structure]
    end

    def destroy
      image = StructureImage.find(params[:id])
      image.destroy
      redirect_to_parent image
    end

    def download
      @image = StructureImage.find(params[:id])
      redirect_to @image.asset.expiring_url(10, params[:style])
    end

    private

    def file_name_param
      params.require(:structure_image)
            .fetch(:asset)
            .original_filename
    end

    def photo_params
      params.require(:structure_image)
            .permit(:asset, :structure_id)
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
