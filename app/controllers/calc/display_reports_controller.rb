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
    @page_title = "Report based on \"#{@audit_report.audit_name}\""
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

  private

  def audit_report_params
    params.require(:audit_report).permit(:report_template_id)
  end

  def content_block_params
    params[:content_block]
  end

  def set_audit_report
    @audit_report = AuditReport.find(params[:audit_report_id])
  rescue ActiveRecord::RecordNotFound
    render nothing: true, status: 403
    false
  end
end