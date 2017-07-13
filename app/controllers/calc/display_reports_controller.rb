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
      user: current_user,
      report_template: @audit_report.report_template)
    @report_templates = ReportTemplate.all
    @attachment = Attachment.new
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

  def custom_template
    create_params = report_template_params.merge(
      organization_id: current_user.organization_id
    )

    @report_template = ReportTemplate.create(create_params)

    @audit_report.update(
      report_template_id: @report_template.id)

    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      user: current_user,
      report_template: @audit_report.report_template)
    @report_templates = ReportTemplate.all
    @attachment = Attachment.new
    return render :edit
  end

  def combine
    @context = DisplayReportContext.new(
      audit_report: @audit_report,
      for_pdf: true,
      user: current_user)

    @reportpdf = render_to_string @context.pdf_options

    params[:attachment]['pdf'].each do |pdffile|
        Attachment.new(
          title: @audit_report.name,
          audit_report_id: @audit_report.id,
          pdf: pdffile).save
    end
    

    new_pdf = CombinePDF.new
    new_pdf << CombinePDF.parse(@reportpdf, allow_optional_content: true)
    params[:attachment]['pdf'].each do |attachment|
      new_pdf << CombinePDF.parse(attachment.read)
    end

    send_data new_pdf.to_pdf,
              filename: "#{@audit_report.name}_combined",
              type: 'application/pdf',
              disposition: 'inline'
  end

  private

  def audit_report_params
    params.require(:audit_report).permit(:report_template_id)
  end

  def report_template_params
    params.require(:report_template).permit(:markdown, :name, :layout)
  end

  def content_block_params
    params[:content_block]
  end

  def attachment_params
    params.require(:attachment).permit(attachment_attributes: [:id, :title, :pdf])
  end

  def set_audit_report
    @audit_report = AuditReport.find(params[:audit_report_id])
  rescue ActiveRecord::RecordNotFound
    render nothing: true, status: 403
    false
  end
end
