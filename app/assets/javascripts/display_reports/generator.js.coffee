class DisplayReports.Generator
  constructor: (params) ->
    displayReport = new DisplayReports.Models.DisplayReport(
      params.display_report)
    page = new DisplayReports.Views.Page(
      el: $('body')
      model: displayReport
      preview_url: params.preview_url
      markdownEditorEl: params.markdownEditorEl
      markdownPreviewEl: params.markdownPreviewEl
      formHtml: params.form_html
    )
    page.render()
