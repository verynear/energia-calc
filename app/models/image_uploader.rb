require "image_processing/mini_magick"

class ImageUploader < Shrine
	
	include ImageProcessing::MiniMagick

	process(:store) do |io, context|
	    { original: io, thumb: resize_to_limit!(io.download, 300, 300) }
	end

	Attacher.validate do
	  validate_extension_inclusion %w[jpg jpeg png gif]
	  # validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
	end
end