class Attachment < ActiveRecord::Base
	include PdfUploader[:pdf]
end
