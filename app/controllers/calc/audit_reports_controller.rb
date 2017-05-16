class Calc::AuditReportsController < SecuredController
  before_filter :audit_digest

  def create
    data_hash = @audit_digest.new_audit(params[:audit_report][:id])
    data = HashWithIndifferentAccess.new(data_hash)
    audit_report = AuditReportCreator.new(
      data: data,
      user: current_user,
      wegoaudit_id: params[:audit_report][:id]).create

    redirect_to calc_audit_report_path(audit_report.id)
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
      redirect_to audit_reports_path
    else
      content = archive.to_s
      send_data(content, filename: archive.basename)
    end

    archive.delete
  end

  def edit
    @audit_report = audit_report
    @page_title = "Edit data for \"#{@audit_report.name}\""

    @context = EditAuditReportContext.new(
      user: current_user,
      audit_report: @audit_report)
  end

  def index
    @page_title = 'View reports'
    @audit_reports = AuditReport.all
  end

  def new
    @user_org = current_user.organization_id
    @page_title = 'Create report'
    @audits = Audit.where(organization_id: @user_org)
    render layout: false
  end

  def show
    @audit_report = audit_report
    @page_title = "Report based on \"#{@audit_report.name}\""
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

  def audit_digest
    @audit_digest ||= AuditDigest.new
  end
end
