class PdfUploader < Shrine

	Attacher.validate do
	  validate_extension_inclusion %w[pdf]
	  # validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
	end
end