class DisplayReports.Views.Photos extends Backbone.View
  template: _.template """
  <h5>Cover photo</h5>
  <div class='gallery js-photos'>
  </div>
  """

  initialize: ->
    @initialSetSelected()

  render: =>
    @$el.append(@template())
    @$photos = @$('.js-photos')
    @collection.each (model) =>
      @$photos.append(
        new DisplayReports.Views.Photo(model: model).render()
      )
    @$el

  initialSetSelected: () ->
    selectedPhotoId = @collection.display_report.get('selected_photo_id')
    return unless selectedPhotoId

    photoToSelect = @collection.find (model) ->
      selectedPhotoId == model.get('id')
    @collection.setSelected(photoToSelect)
