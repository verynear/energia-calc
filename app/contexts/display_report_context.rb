class DisplayReportContext < BaseContext
  attr_accessor :audit_report,
                :report_template,
                :for_pdf,
                :user

  def initialize(*)
    super
    raise 'audit_report' unless audit_report
    self.for_pdf = false if @for_pdf.nil?
  end

  def as_json
    {
      form_html: form_html,
      display_report: display_report_as_json,
      preview_url: preview_report_url
    }
  end

  def display_report_for_form
    DisplayReportBuilder.new(
      audit_report: audit_report,
      audit_report_calculator: audit_report_calculator,
      contentblock_mode: 'active',
      default_markdown: '',
      markdown_source: audit_report.report_template
    ).display_report
  end
  memoize :display_report_for_form

  def display_report_for_preview
    DisplayReportBuilder.new(
      audit_report: audit_report,
      audit_report_calculator: audit_report_calculator,
      contentblock_mode: 'rendered',
      default_markdown: '',
      for_pdf: for_pdf,
      markdown_source: audit_report.report_template
    ).display_report
  end
  memoize :display_report_for_preview

  def filename
    audit_report.name
  end

  def form_html
    display_report_for_form.formatted_report
  end

  def layout
    audit_report.report_template.layout
  end

  def preview_layout
    audit_report.report_template
  end

  def pdf_options
    {
      pdf: filename,
      page_size: 'Letter',
      layout: 'calc/layouts/pdf.html.erb',
      template: "calc/layouts/pdf/#{layout}/body.html.erb",
      disable_smart_shrinking: true,
      locals: { context: self },
      margin: {
        top: 10,
        bottom: 10,
        left: 10,
        right: 10
      },
      header: {
        html: {
          locals: { context: self },
          template: "calc/layouts/pdf/#{layout}/header.html.erb"
        }
      },
      footer: {
        locals: { report: audit_report },
        html: {
          locals: { context: self },
          template: "calc/layouts/pdf/#{layout}/footer.html.erb"
        }
      },
      disposition: 'inline'
    }
  end

  def pdf_path
    url_helpers.calc_audit_report_display_path(audit_report)
  end

  def preview_html
    display_report_for_preview.formatted_report
  end

  def report
    AuditReportPresenter.new(audit_report)
  end
  memoize :report

  private

  def audit_report_calculator
    AuditReportCalculator.new(
      audit_report: audit_report)
  end
  memoize :audit_report_calculator

  def display_report_as_json
    DisplayReportSerializer.new(
      audit_report: audit_report,
      display_report: display_report_for_preview).as_json
  end

  def preview_template_url
    url_helpers.preview_calc_audit_report_display_path(audit_report)
  end

  def preview_report_url
    url_helpers.preview_calc_audit_report_display_path(audit_report)
  end
end
