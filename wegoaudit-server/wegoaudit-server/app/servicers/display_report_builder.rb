class DisplayReportBuilder < Generic::Strict
  attr_accessor :audit_report,
                :audit_report_calculator,
                :contentblock_mode,
                :default_markdown,
                :for_pdf,
                :markdown_source

  def initialize(*args)
    super(*args)
    raise unless audit_report_calculator
    self.contentblock_mode ||= 'rendered'
    self.markdown_source ||= audit_report
    self.for_pdf ||= false
  end

  def display_report
    DisplayReport.new(
      registers: {
        audit_report_calculator: audit_report_calculator,
        mode: contentblock_mode,
        for_pdf: for_pdf,
        audit_report: audit_report
      },
      filename: audit_report.name,
      markdown: markdown,
      locals: build_locals
    )
  end
  memoize :display_report

  private

  def build_locals
    locals = audit_report.field_values.each_with_object({}) do |field_value, hash|
      if field_value.value.present?
        value = field_value.value
      else
        value = "<strong>[#{field_value.field_api_name}]</strong>"
      end
      hash[field_value.field_api_name] = value
    end
    locals['user_name'] = audit_report.user.name
    locals
  end

  def markdown
    persisted_markdown.present? ? persisted_markdown : default_markdown
  end

  def persisted_markdown
    markdown_source.markdown
  end
end
