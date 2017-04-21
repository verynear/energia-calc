class DisplayReports.Collections.Photos extends Backbone.Collection
  model: DisplayReports.Models.Photo

  setSelected: (photo) ->
    photo.set('selected', true)
    @each (model) ->
      model.set('selected', false) unless model == photo
