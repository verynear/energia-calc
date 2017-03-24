class AuditReports.Views.MeasurePhoto extends Backbone.View
  className: "gallery__item"

  template: _.template """
    <a class="gallery__modal-trigger js-gallery"
      href="<%= mediumUrl %>"
      data-fancybox-group="gallery">
        <img src="<%= thumbUrl %>">
    </a>
    <input type="radio"
      <%= checked %>
      name="select-measure-image"
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

  measureSelectionUrl: () ->
    measureSelection = @model.get('measure_selection')
    reportId = measureSelection.get('report_id')
    id = measureSelection.get('id')
    "/calc/audit_reports/#{reportId}/measure_selections/#{id}"

  onChangeSelectImage: (event) ->
    @model.collection.setSelected(@model)

    $.ajax(
      method: 'PUT'
      url: @measureSelectionUrl()
      data:
        measure_selection:
          wegoaudit_photo_id: @model.get('id')
      success: (data) =>
        @model.get('measure_selection').set(data.measure_selection)
    )
