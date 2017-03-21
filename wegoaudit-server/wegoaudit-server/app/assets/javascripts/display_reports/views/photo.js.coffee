class DisplayReports.Views.Photo extends Backbone.View
  className: "gallery__item"

  template: _.template """
    <a class="gallery__modal-trigger js-gallery"
      href="<%= mediumUrl %>"
      data-fancybox-group="gallery">
        <img src="<%= thumbUrl %>">
    </a>
    <input type="radio"
      <%= checked %>
      name="select-display-report-image"
      id="<%= id %>"
      class="js-select-image-radio">
  """

  events:
    'change .js-select-image-radio': 'onChangeSelectImage'

  render: =>
    @$el.html @template(
      checked: if @model.get('selected') then 'checked' else ''
      id: @model.get('id')
      mediumUrl: @model.get('medium_url')
      thumbUrl: @model.get('thumb_url')
    )
    @$el

  auditReportUrl: () ->
    displayReport = @model.get('display_report')
    reportId = displayReport.get('id')
    "/audit_reports/#{reportId}"

  onChangeSelectImage: (event) ->
    @model.collection.setSelected(@model)

    $.ajax(
      method: 'PUT'
      url: @auditReportUrl()
      data:
        audit_report:
          wegoaudit_photo_id: @model.get('id')
      success: (data) =>
        @model.get('display_report').set(data.display_report)
    )
