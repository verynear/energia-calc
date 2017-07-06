class Calc::DisplayReportsController < SecuredController
  before_action :set_audit_report

  def change_template
    @audit_report.attributes = audit_report_params
    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      user: current_user)

    render json: {
      form: @context.form_html,
      preview: @context.preview_html
    }
  end

  def edit
    @page_title = "Report based on \"#{@audit_report.name}\""
    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      user: current_user)
    @report_templates = ReportTemplate.all
  end

  def preview
    ContentBlockSaver.new(
      audit_report_id: @audit_report.id,
      content_block_params: content_block_params
    ).execute

    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      user: current_user)

    render text: @context.preview_html
  end

  def show
    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      for_pdf: true,
      user: current_user)

    render @context.pdf_options
  end

  def update
    @audit_report.update_attributes!(audit_report_params)

    ContentBlockSaver.new(
      audit_report_id: @audit_report.id,
      content_block_params: content_block_params
    ).execute if content_block_params

    redirect_to action: :edit
  end

  def combine
    @attachment = Attachment.new

    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      for_pdf: true,
      user: current_user)

    @reportpdf = render_to_string @context.pdf_options

    @attachment = params[:pdf]

    @combined_pdf = PdfCombiner.new(
      reportpdf: @reportpdf,
      attachments: @attachment,
      filename: @audit_report.name.to_s,
      current_user: current_user
      ).combined

    send_data @combined_pdf.to_pdf, filename: filename, type: "application/pdf"
  end

  private

  def audit_report_params
    params.require(:audit_report).permit(:report_template_id)
  end

  def content_block_params
    params[:content_block]
  end

  def attachment_params
    params[:pdf]
  end

  def set_audit_report
    @audit_report = AuditReport.find(params[:audit_report_id])
  rescue ActiveRecord::RecordNotFound
    render nothing: true, status: 403
    false
  end
end
