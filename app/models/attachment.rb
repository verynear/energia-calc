class Attachment < ActiveRecord::Base
	include PdfUploader::Attachment.new(:pdf)

	belongs_to :audit_report
end
