class AuditReports.Views.MeasureSummary extends Backbone.View
  className: "js-measure-summary measure__summary"

  template: _.template """
    <div class="measure__summary__title">
      Measure Summary
    </div>

    <div class="js-measure-calc-fields">
    </div>

    <div class="measure__summary__section-title">
      Overall usage values (before measure)
    </div>

    <div class="js-usage-values">
    </div>

    <div class="measure__summary__section-title">
      Calculation results
    </div>
  """

  render: =>
    @$el.html(@template())
    @$usageValues = @$('.js-usage-values')
    @$measureCalcFieldsRow = @$('.js-measure-calc-fields')

    @_renderMeasureCalcFields()
    @_renderUsageValues()
    @_renderCalculatedValues()

    $row = $("<div class='row'></div>")
    @$el.append($row)

    descriptionCalcField =
      new AuditReports.Views.DescriptionCalcField(
        model: @model,
      )
    $row.append(descriptionCalcField.render())
    recommendationCalcField =
      new AuditReports.Views.RecommendationCalcField(
        model: @model,
      )
    $row.append(recommendationCalcField.render())
    @$el

  _renderCalculatedValues: ->
    calculatedValues =
      new AuditReports.Views.MeasureSummaryCalculatedValues(model: @model)
    @$el.append(calculatedValues.render())

  _renderMeasureCalcFields: ->
    $row = null
    count = 0
    @model.get('calc_field_values').each (calcFieldValue) =>
      if count % 4 == 0
        $row = $("<div class='row'></div>")
        @$measureCalcFieldsRow.append($row)
      measureCalcField = new AuditReports.Views.MeasureCalcField(model: calcFieldValue)
      $row.append(measureCalcField.render())
      count += 1

  _renderUsageValues: ->
    $row = null
    count = 0
    _(@model.get('before_usage_values')).each (options, key) =>
      if count % 4 == 0
        $row = $("<div class='row'></div>")
        @$usageValues.append($row)
      staticCalcField = new AuditReports.Views.StaticCalcField(
        name: options.title,
        value: options.value
      ).render()
      $row.append(staticCalcField)
      count += 1
