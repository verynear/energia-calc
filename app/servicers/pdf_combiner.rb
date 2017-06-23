class PdfCombiner < Generic::Strict
  require 'pdfkit'
  require 'combine_pdf'

  attr_accessor :audit_report,
                :display_report,
                :pdf_url,
                :attachments,
                :filename,
                :current_user,
                :markdown_source

  def initialize(*)
    super
    self.pdf_url = pdf_url
    self.attachments = attachments
    self.filename = filename
    self.current_user = current_user
  end

  def absolute_url
    Retrocalc::BASE_URL + pdf_url
  end

  def new_filename
    filename + "_combined.pdf"
  end

  # def pdf_as_string
  #   render_to_string(pdf_url)
  # end

  def combined
    rendered_pdf = PDFKit.new(pdf_url).to_pdf
    attachments_file = attachments.read
    # rendered_attachments = PDFKit.new(attachments_file)
    new_pdf = CombinePDF.new
    new_pdf << CombinePDF.parse(rendered_pdf, allow_optional_content: true)
    new_pdf << CombinePDF.parse(attachments_file)
    new_pdf.to_pdf
  end
end