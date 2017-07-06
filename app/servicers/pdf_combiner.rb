class PdfCombiner < Generic::Strict
  require 'pdfkit'
  require 'combine_pdf'

  attr_accessor :audit_report,
                :display_report,
                :reportpdf,
                :attachments,
                :filename,
                :current_user,
                :markdown_source

  def initialize(*)
    super
    self.reportpdf = reportpdf
    self.attachments = attachments
    self.filename = filename
    self.current_user = current_user
  end

  # def absolute_url
  #   Retrocalc::BASE_URL + pdf_url
  # end

  def new_filename
    filename + "_combined.pdf"
  end

  def attached_file
    @file = attachments.open
  end

  def combined
    new_pdf = CombinePDF.new
    new_pdf << CombinePDF.parse(reportpdf, allow_optional_content: true)
    new_pdf << CombinePDF.parse(@file, allow_optional_content: true)
    new_pdf.to_pdf new_filename
  end
end