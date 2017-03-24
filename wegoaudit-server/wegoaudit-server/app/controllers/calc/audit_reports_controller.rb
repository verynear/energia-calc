class Calc::AuditReportsController < SecuredController
  def create
    data = wegoaudit_client.audit(params[:audit_report][:id])
    audit_report = AuditReportCreator.new(
      data: data,
      user: current_user,
      wegoaudit_id: params[:audit_report][:id]).create

    redirect_to calc_audit_report_path(audit_report.id)

  rescue WegoauditClient::ApiError => e
    flash[:alert] = "Error importing audit: #{e.message}"
    redirect_to calc_audit_reports_path
  end

  def destroy
    audit_report.destroy
    redirect_to calc_audit_reports_path
  end

  def download_usage
    archive = AuditUsageDataArchive.new(audit_report)
    archive.build

    if archive.entries.blank?
      flash[:alert] = 'No data available to download.'
      redirect_to calc_audit_reports_path
    else
      content = archive.to_s
      send_data(content, filename: archive.basename)
    end

    archive.delete
  end

  def edit
    @audit_report = audit_report
    @page_title = "Edit data for \"#{@audit_report.audit_name}\""

    @context = EditAuditReportContext.new(
      user: current_user,
      audit_report: @audit_report)
  end

  def index
    @page_title = 'View reports'
    @audit_reports = AuditReport.all
  end

  def new
    @page_title = 'Create report'
    @audits = wegoaudit_client.audits_list.map do |hash|
      Wegoaudit::Audit.new(hash)
    end
    render layout: false
  rescue WegoauditClient::ApiError
    @error = 'Error retrieving list of audits from WegoAudit'
    render layout: false
  end

  def show
    @audit_report = audit_report
    @page_title = "Report based on \"#{@audit_report.audit_name}\""

    @context = ShowAuditReportContext.new(
      user: current_user,
      audit_report: @audit_report)
  end

  def update
    audit_report.update!(audit_report_params)

    json = {
      audit_report_summary: AuditReportSummarySerializer.new(
        audit_report: audit_report
      ).as_json
    }

    render json: json
  end

  private

  def audit_report
    AuditReport.find(params[:id])
  end

  def audit_report_params
    params.require(:audit_report).permit(:name, :wegoaudit_photo_id)
  end

  def wegoaudit_client
    @client ||= WegoauditClient.new(organization_id: current_user.organization_id)
  end
end
