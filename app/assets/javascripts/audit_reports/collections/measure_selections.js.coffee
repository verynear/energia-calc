class AuditReports.Collections.MeasureSelections extends Backbone.Collection
  model: AuditReports.Models.MeasureSelection
  comparator: 'calculate_order'

  setActive: (activeMeasure) ->
    activeMeasure.set('active', true)
    @each (model) ->
      model.set('active', false) unless model == activeMeasure
