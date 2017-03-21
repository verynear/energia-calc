class DisplayReportSerializer < Generic::Strict
  attr_accessor :audit_report,
                :display_report

  def as_json
    {
      id: audit_report.id,
      name: audit_report.name,
      markdown: display_report.markdown,
      rendered_html: display_report.formatted_report,
      photos: audit_report.audit.photos,
      selected_photo_id: audit_report.wegoaudit_photo_id
    }
  end
end
