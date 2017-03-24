class ReportTemplateContext < BaseContext
  attr_accessor :report_template,
                :user

  def as_json
    {
      display_report: display_report_as_json,
      preview_url: preview_template_url
    }
  end

  def display_report
    DisplayReportBuilder.new(
      audit_report_calculator: audit_report_calculator,
      audit_report: default_audit_report,
      contentblock_mode: 'blank',
      default_markdown: '',
      markdown_source: report_template
    ).display_report
  end
  memoize :display_report

  def layout
    report_template.layout
  end

  def preview_html
    display_report.formatted_report
  end

  private

  def audit_report_calculator
    AuditReportCalculator.new(
      audit_report: default_audit_report)
  end
  memoize :audit_report_calculator

  def build_calc_field_values(options)
    options.map do |key, value|
      CalcFieldValue.new(field_api_name: key, value: value)
    end
  end

  def default_audit_report
    AuditReport.new(
      user: calc_user,
      name: 'Sample Report',
      created_at: 10.days.ago,
      updated_at: 5.minutes.ago,
      calc_field_values: build_calc_field_values(
        audit_date: 15.days.ago,
        contact_name: 'Crandle Berry',
        contact_company: 'Pumpkin Investment Partners',
        contact_email: 'Cran_Berry@gmail.com',
        contact_address: '1111 W Pecan Ave',
        contact_city: 'Chicago',
        contact_state: 'IL',
        contact_zip: '60617',
        contact_phone: '(773) 111-1111',
        building_name: 'Mapleleaf Commons',
        building_address: '300 N Spiced Apple Dr',
        building_city: 'Chicago',
        building_state: 'IL',
        building_zip: '60614'
      )
    )
  end
  memoize :default_audit_report

  def display_report_as_json
    DisplayReportSerializer.new(
      audit_report: default_audit_report,
      display_report: display_report).as_json
  end

  def preview_template_url
    url_helpers.preview_calc_report_templates_path
  end
end
