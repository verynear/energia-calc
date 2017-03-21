class AuditReports.Collections.MeasurePhotos extends Backbone.Collection
  model: AuditReports.Models.MeasurePhotos

  setSelected: (photo) ->
    photo.set('selected', true)
    @each (model) ->
      model.set('selected', false) unless model == photo
