class AuditReports.Views.MeasureSummaryCalculatedValues extends Backbone.View
  className: "row js-calculated-values"

  initialize: ->
    @model.on 'change', @render

  calculationTemplate: _.template """
    <div class="data col-auto"
         data-measure-calculation='<%= name %>'>
      <div class="data__label"><%= title %></div>
      <div class="data__value"><%= value %></div>
    </div>
  """

  render: =>
    @$el.html('')
    _(@model.get('results')).each (data) =>
      @$el.append(@calculationTemplate(data))
    @$el
