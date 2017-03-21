class AuditReports.Views.MeasurePhotos extends Backbone.View
  className: "gallery"

  initialize: ->
    @initialSetSelected()

  render: =>
    @collection.each (model) =>
      @$el.append(
        new AuditReports.Views.MeasurePhoto(model: model).render()
      )
    @$el

  initialSetSelected: () ->
    selectedPhotoId = @collection.measure_selection.get('selected_photo_id')
    return unless selectedPhotoId

    photoToSelect = @collection.find (model) ->
      selectedPhotoId == model.get('id')
    @collection.setSelected(photoToSelect)
